class ApplicationController < ActionController::Base
  include Knock::Authenticable

  # this is used when building instance (returns 422) - it is hijacked in v1 from middleware which does validation (returns 403)
  rescue_from AbstractMessage::ValidationError,
                                        with: lambda {|exception| render_exception(:unprocessable_entity, exception)}

  rescue_from Aws::DynamoDB::Errors::ServiceError, Errors::ResourceNotFound, ActionController::RoutingError,
                                        with: lambda {|exception| render_exception(:not_found, exception)}
  rescue_from Errors::RequestForbidden, with: lambda {|exception| render_exception(:forbidden, exception)}
  rescue_from CanCan::AccessDenied,     with: lambda {|exception| render_exception(:unauthorized, exception)}
  rescue_from Errno::ECONNREFUSED,      with: lambda {|exception| render_exception(:service_unavailable, exception)}

  # TODO: use render_exception instead
  rescue_from TypeError, ArgumentError, with: lambda {|exception| render_error(:bad_request, exception)}
  rescue_from NameError, RuntimeError,  with: lambda {|exception| render_error(:internal_server_error, exception)}

  # save uuid to global state for use in logger and print request stats
  before_action do
    # override rails uuid if it is already set in ServicesRoutesMiddleware#call
    request.request_id = RequestStore.store[:uuid] if RequestStore.store[:uuid]

    # if its not set then copy to store one provided by rails
    RequestStore.store[:uuid] ||= request.request_id

    # log request stats
    puts "[#{Time.now}] [#{Rails.application.class.parent}] [#{RequestStore.store[:uuid]}] [INFO]  REQUEST STARTED:" # extra space for alignment
    puts '=' * 120
    puts "Method: #{request.request_method}"
    puts "Path: #{request.fullpath}"
    puts "Format: #{request.format}"
    puts "Query parameters: #{request.query_parameters}"
    puts "Payload: #{request.raw_post}" unless request.form_data? or request.get?
    puts "Method called: #{params[:controller].camelize}Controller##{params[:action]}\n\n"
  end

  protected

  # success/error output
  # TODO: merge this with render_exception below
  def render_error(status, exception)
    logger.error status.to_s +  " " + exception.to_s
    respond_to do |format|
      format.all { head status, message: exception.message}
    end
    # TODO: replace respond_to with this after removing non json responses
    # render json: {message: exception.message}, status: status
  end

  def render_exception(status_symbol, exception)
    status_code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status_symbol]
    logger.error "#{status_code} #{status_symbol.to_s.humanize}: #{exception.class}"
    standard_error_message(exception.message, status_code)
  end

  def standard_success_message(message, status_code=200)
    render json: {message: message, pedmatch_uuid: request.uuid}, status: status_code
  end

  def standard_error_message(message, status_code=500)
    AppLogger.log_error(self.class.name, message)
    render json: {message: message, pedmatch_uuid: request.uuid}, status: status_code
  end

  # enqueue message
  # TODO: remove me, use MessageType#save!
  def queue_message(message, message_type)
    queue_name = Rails.configuration.environment.fetch('queue_name')
    logger.debug "Patient API publishing to queue: #{queue_name}..."
    Aws::Sqs::Publisher.publish(message, request.uuid, queue_name)
    true
  end

  # validate message
  # TODO: remove me, use MessageType#save!
  def validate_patient_state(message, message_type)
    AppLogger.log(self.class.name, "Validating messesage of type [#{message_type}]")
    message_type = {message_type => message}
    result = StateMachine.validate(message_type, request.uuid, token)

    raise Errors::RequestForbidden, "Incoming message failed patient state validation: #{result}" if result != 'true'
  end

  # validate and enqueue message
  # TODO: remove me, use MessageType#save!
  def validate_patient_state_and_queue(message, message_type)
    AppLogger.log(self.class.name, "Validating messesage of type [#{message_type}]")
    # job = JobBuilder.new(message_type.to_s.gsub("Message", "Job")).job
    message_type = {message_type => message}
    result = StateMachine.validate(message_type, request.uuid, token)

    raise Errors::RequestForbidden, "Incoming message failed patient state validation: #{result}" if result != 'true'

    queue_name = Rails.configuration.environment.fetch('queue_name')
    logger.debug "Patient API publishing to queue: #{queue_name}..."
    Aws::Sqs::Publisher.publish(message, request.uuid, queue_name)
    # job.perform_later(message)
  end
end

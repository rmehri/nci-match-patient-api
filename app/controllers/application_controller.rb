class ApplicationController < ActionController::Base
  include Knock::Authenticable

  rescue_from Aws::DynamoDB::Errors::ServiceError, Errors::ResourceNotFound, with: lambda { | exception | render_error(:not_found, exception)}
  rescue_from Errors::RequestForbidden, with: lambda { | exception | render_error_with_message(:forbidden, exception)}
  rescue_from CanCan::AccessDenied, with: lambda { | exception | render_error_with_message(:unauthorized, exception)}
  rescue_from TypeError, ArgumentError, ActionController::RoutingError, with: lambda { |exception| render_error(:bad_request, exception) }
  rescue_from NameError, RuntimeError, with: lambda { |exception| render_error(:internal_server_error, exception) }

  # this is used when building instance (returns 422) - it is hijacked in v1 from middleware (returns 403)
  rescue_from AbstractMessage::ValidationError, with: lambda { |exception| render_error(:unprocessable_entity, exception) }

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  protected

  def render_error(status, exception)
    logger.error status.to_s +  " " + exception.to_s
    respond_to do |format|
      format.all { head status, :message => exception.message}
    end
    # render :json => {:message => exception.message}, :status => status
  end

  def render_error_with_message(status, exception)
    logger.error status.to_s +  " " + exception.to_s
    render :json => {:message => exception.message}, :status => status
  end

  def standard_success_message(message, status_code=200)
    render :json => {:message => message}, :status => status_code
  end

  def standard_error_message(error_message, error_code=500)
    AppLogger.log_error(self.class.name, error_message)
    render :json => {:message => error_message}, :status => error_code
  end

  def queue_message(message, message_type)
    queue_name = Rails.configuration.environment.fetch('queue_name')
    logger.debug "Patient API publishing to queue: #{queue_name}..."
    Aws::Sqs::Publisher.publish(message, request.uuid, queue_name)
    true
  end

  def validate_patient_state(message, message_type)
    AppLogger.log(self.class.name, "Validating messesage of type [#{message_type}]")
    message_type = {message_type => message}
    result = StateMachine.validate(message_type, request.uuid, token)

    raise Errors::RequestForbidden, "Incoming message failed patient state validation: #{result}" if result != 'true'
  end

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

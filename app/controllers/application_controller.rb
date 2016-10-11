class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  protected
  def standard_success_message(message)
    render :json => {:message => message}, :status => 200
  end

  def standard_error_message(error_message, error_code=500)

    logger.error error_message
    render status: error_code, json: {:message => error_message}
  end

  def queue_message(message, message_type)
    queue_name = Rails.configuration.environment.fetch('queue_name')
    logger.debug "Patient API publishing to queue: #{queue_name}..."
    Aws::Sqs::Publisher.publish(message, queue_name)
    true
  end

  def validate_patient_state(message, message_type)

    logger.info "Validating messesage of type [#{message_type}]"

    message_type = {message_type => message}
    result = StateMachine.validate(message_type)

    if result != 'true'
      raise "Incoming message failed patient state validation: #{result}"
    end

    true
  end

  def validate_patient_state_and_queue(message, message_type)

    AppLogger.log(self.class.name, "Validating messesage of type [#{message_type}]")

    message_type = {message_type => message}
    result = StateMachine.validate(message_type)

    if result != 'true'
      raise "Incoming message failed patient state validation: #{result}"
    end

    queue_name = Rails.configuration.environment.fetch('queue_name')
    logger.debug "Patient API publishing to queue: #{queue_name}..."
    Aws::Sqs::Publisher.publish(message, queue_name)

  end
end

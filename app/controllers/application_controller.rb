class ApplicationController < ActionController::Base

  # rescue_from Aws::DynamoDB::Errors::ServiceError, with: :not_found
  # rescue_from Exception, with: :not_found
  # rescue_from ActionController::RoutingError, with: :not_found


  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  protected

  def raise_not_found
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end

  def not_found
    respond_to do |format|
      format.html { render :json => {:message => "ResourceNotFound", :status => 404}, :layout => false, :status => :not_found }
      format.xml { head :not_found }
      format.any { head :not_found }
    end
  end

  def error
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/500", :layout => false, :status => :error }
      format.xml { head :not_found }
      format.any { head :not_found }
    end
  end


  def standard_success_message(message)
    render :json => {:message => message}, :status => 200
  end

  def standard_error_message(error_message, error_code=500)
    logger.error error_message
    render :json => {:message => error_message, status => error_code}, :status => error_code
  end

  def get_url_path_segments
    return request.fullpath.split("/")
  end

  def get_post_data(patient_id)
    json_data = JSON.parse(request.raw_post)
    logger.info "Patient Api received message: #{json_data.to_json}"
    json_data.deep_transform_keys!(&:underscore).symbolize_keys!

    json_data.merge!({:patient_id => patient_id})

    logger.info "========== message after merge: #{json_data}"
    json_data
  end


  def get_patient_id_from_url
    parts = get_url_path_segments
    logger.info "============== url parts: #{parts}"
    index = parts.index("patients")
    patient_id = parts[index+1]
    return patient_id
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

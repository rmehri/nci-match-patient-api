class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  protected
  def standard_success_message(message)
    render :json => {:message => message}, :status => 200
  end

  def standard_error_message(error_message, error_code=500)

    AppLogger.log_error(self.class.name, error_message)
    render status: error_code, json: {:message => error_message}
  end

  def get_url_path_segments
    return request.fullpath.split("/")
  end

  def get_post_data(patient_id)
    json_data = JSON.parse(request.raw_post)
    AppLogger.log(self.class.name, "Patient Api received message: #{json_data.to_json}")
    json_data.deep_transform_keys!(&:underscore).symbolize_keys!

    json_data.merge!({:patient_id => patient_id})

    p "========== message after merge: #{json_data}"
    json_data
  end

  def get_post_data_for_variant_report_status
    parts = get_url_path_segments
    p "========= part length: #{parts.length}"
    raise "Variant report status url missing required parameter" if parts.length < 9

    patient_id = parts[parts.index("patients")+1]
    vr_index = parts.index("variant_reports")
    molecular_id = parts[vr_index+1]
    analysis_id = parts[vr_index+2]

    confirm = parts[vr_index+3].downcase
    if confirm == 'confirm'
      confirm = 'CONFIRMED'
    elsif confirm == 'reject'
      confirm = 'REJECTED'
    end

    message = {"patient_id" => patient_id, "molecular_id" => molecular_id, "analysis_id" => analysis_id, "status" => confirm}

    json_data = get_post_data(patient_id)
    message["comment"] = json_data[:comment]
    message["comment_user"] = json_data[:comment_user]

    message.deep_transform_keys!(&:underscore).symbolize_keys!
    p "========== Composed vr status message: #{message}"
    message
  end

  def get_post_data_for_assignment_status
    parts = get_url_path_segments
    p "========= part length: #{parts.length}"
    raise "Variant report status url missing required parameter" if parts.length < 9

    patient_id = parts[parts.index("patients")+1]
    vr_index = parts.index("assignment_reports")
    molecular_id = parts[vr_index+1]
    analysis_id = parts[vr_index+2]

    confirm = parts[vr_index+3].downcase
    confirm = if confirm == 'confirm' then 'CONFIRMED' else confirm end

    message = {"patient_id" => patient_id, "molecular_id" => molecular_id, "analysis_id" => analysis_id, "status" => confirm}

    json_data = get_post_data(patient_id)
    message["comment"] = json_data[:comment]
    message["comment_user"] = json_data[:comment_user]

    message.deep_transform_keys!(&:underscore).symbolize_keys!
    p "========== Composed vr status message: #{message}"
    message
  end

  # def get_token

  def get_patient_id_from_url
    parts = get_url_path_segments
    p "============== url parts: #{parts}"
    index = parts.index("patients")
    patient_id = parts[index+1]
    return patient_id
  end

  def queue_message(message, message_type)
    queue_name = ENV['queue_name']
    Rails.logger.debug "Patient API publishing to queue: #{queue_name}..."
    Aws::Sqs::Publisher.publish(message, queue_name)
    true
  end

  def validate_patient_state(message, message_type)

    AppLogger.log(self.class.name, "Validating messesage of type [#{message_type}]")

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

    queue_name = ENV['queue_name']
    Rails.logger.debug "Patient API publishing to queue: #{queue_name}..."
    Aws::Sqs::Publisher.publish(message, queue_name)

  end
end


class ServicesController < ApplicationController
  # before_action :authenticate

  # POST /trigger
  def trigger
    message = get_post_data

    begin
      type = MessageValidator.get_message_type(message)
      raise "Incoming message has UNKNOWN message type" if (type == 'UNKNOW')

      error = MessageValidator.validate_json_message(type, message)
      raise "Incoming message failed message schema validation: #{error}" if !error.nil?

      status = validate_patient_state(message, type)
      raise "Incoming message failed patient state validation" if (status == false)

      render status: 200, json: '{"status" : "Success", "message" :"Message has been processed successfully"}'
    rescue => error
      standard_error_message(error)
    end

  end

  def get_post_data
    json_data = JSON.parse(request.raw_post)
    AppLogger.log("ServiceController", "Patient Api received message: #{json_data.to_json}")
    json_data.deep_transform_keys!(&:underscore).symbolize_keys!
    json_data
  end

  def validate_patient_state(message, message_type)

    AppLogger.log(self.class.name, "Validting messesage of type [#{message_type}]")

    message_type = {message_type => message}
    res = StateMachine.validate(message_type)

    if res == "true"
      queue_name = ENV['queue_name']
      Rails.logger.debug "Patient API publishing to queue: #{queue_name}..."
      Aws::Sqs::Publisher.publish(message, queue_name)
      return true
    else
      return false
    end


  end

end
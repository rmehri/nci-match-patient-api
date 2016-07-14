
class ServiceController < ApplicationController
  # before_action :authenticate

  # POST /trigger
  def trigger
    message = get_post_data
    Rails.logger.debug "Trigger get message: #{message}"

    if (!message[:status].nil? && message[:status] == 'REGISTRATION')
      process_message("Cog")
    elsif (!message[:specimen_received].nil?)
      process_message("SpecimenReceived")
    elsif (!message[:specimen_shipped].nil?)
      process_message("SpecimenShipped")
    else
      render status: 200, json: '{"Advanced message":"Do not know what to do"}'
    end

  end

  def process_message(*message_type)
    if validate_and_queue(message_type)
      render_validation_success
    else
      render_validation_failure;
    end
  end

  def render_validation_success
    render status: 200, json: {:status => "Success"}
  end

  def render_validation_failure
    render status: 400, json: {:status => "Failure", :message => "Validation failed. Please check all required fields are present"}
  end

  def get_post_data
    json_data = JSON.parse(request.raw_post)
    Rails.logger.debug "Got message: #{json_data.to_json}"
    json_data.deep_transform_keys!(&:underscore).symbolize_keys!
    json_data
  end

  def validate_and_queue(*message_type)

    Rails.logger.debug "Message_type val: #{message_type}"

    message = get_post_data
    message_type = {message_type[-1][-1] => message}
    Rails.logger.debug "Message type: #{message_type}"

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
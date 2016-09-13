module V1
  class ServicesController < ApplicationController
    # before_action :authenticate

    # POST /api/v1/patients/{patient_id}
    def trigger

      patient_id = get_patient_id_from_url
      message = get_post_data(patient_id)


      p "======== found patient id: #{patient_id}"

      begin
        type = MessageValidator.get_message_type(message)
        raise "Incoming message has UNKNOWN message type" if (type == 'UNKNOWN')

        error = MessageValidator.validate_json_message(type, message)
        raise "Incoming message failed message schema validation: #{error}" if !error.nil?

        if (type == 'VariantReport' && message[:tsv_file_name].nil?)
          status = queue_message(message, type)
        else
          status = validate_patient_state_and_queue(message, type)
        end

        raise "Incoming message failed patient state validation" if (status == false)

        standard_success_message("Message has been processed successfully")
      rescue => error
        standard_error_message(error.message)
      end

    end

    # PUT /api/v1/patients/variant/{variant_uuid}{checked|unchecked}
    def variant_status

      begin

        message = ConfirmVariantMessage.from_url get_url_path_segments
        post_data = get_post_data("")
        message['comment'] = post_data[:comment]
        message['comment_user'] = post_data[:comment_user]

        response_json = PatientProcessor.run_service("/confirm_variant", message)

        AppLogger.log(self.class.name, "\nResponse from Patient Processor: #{response_json}")
        standard_success_message(JSON.parse(response_json)['message'])

      rescue => error
        standard_error_message(error.message)
      end
    end

    # put /api/v1/patients/{patient_id}/variant_reports/{molecular_id}/{analysis_id}/{confirm|reject}
    def variant_report_status
      begin
        p "================ confirming variant report"
        message = get_post_data_for_variant_report_status

        type = MessageValidator.get_message_type(message)
        raise "Incoming message has UNKNOWN message type" if (type == 'UNKNOWN')

        error = MessageValidator.validate_json_message(type, message)
        raise "Incoming message failed message schema validation: #{error}" if !error.nil?
        p "=========== input data: #{message}"

        success = validate_patient_state(message, type)
        result = if success then 'Success' else 'Failure' end
        result = PatientProcessor.run_service('/confirmVariantReport', message) if success
        standard_success_message(result)
      rescue => error
        standard_error_message(error.message)
      end
    end

    # PUT /api/v1/patients/{patient_id}/assignment_reports/{date_assigned}/confirm
    def assignment_confirmation
      begin
        patient_id = get_patient_id_from_url
        message = get_post_data(patient_id)

        type = MessageValidator.get_message_type(message)
        raise "Incoming message has UNKNOWN message type" if (type == 'UNKNOWN')

        error = MessageValidator.validate_json_message(type, message)
        raise "Incoming message failed message schema validation: #{error}" if !error.nil?
        p "=========== input data: #{message}"

        success = validate_patient_state(message, type)
        result = PatientProcessor.run_service('/confirmAssignment', message)
        standard_success_message(result)
      rescue => error
        standard_error_message(error.message)
      end
    end

    # def get_post_data(patient_id)
    #   json_data = JSON.parse(request.raw_post)
    #   AppLogger.log(self.class.name, "Patient Api received message: #{json_data.to_json}")
    #   json_data.deep_transform_keys!(&:underscore).symbolize_keys!
    #
    #   json_data.merge!({:patient_id => patient_id})
    #
    #   p "========== message after merge: #{json_data}"
    #   json_data
    # end

    # def get_patient_id_from_url
    #   parts = get_url_path_segments
    #   p "============== url parts: #{parts}"
    #   index = parts.index("patients")
    #   patient_id = parts[index+1]
    #   return patient_id
    # end

    # def queue_message(message, message_type)
    #   queue_name = ENV['queue_name']
    #   Rails.logger.debug "Patient API publishing to queue: #{queue_name}..."
    #   Aws::Sqs::Publisher.publish(message, queue_name)
    #   true
    # end

    # def validate_patient_state(message, message_type)
    #
    #   AppLogger.log(self.class.name, "Validating messesage of type [#{message_type}]")
    #
    #   message_type = {message_type => message}
    #   result = StateMachine.validate(message_type)
    #
    #   if result != 'true'
    #     raise "Incoming message failed patient state validation: #{result}"
    #   end
    #
    #   queue_name = ENV['queue_name']
    #   Rails.logger.debug "Patient API publishing to queue: #{queue_name}..."
    #   Aws::Sqs::Publisher.publish(message, queue_name)
    #
    # end

  end
end

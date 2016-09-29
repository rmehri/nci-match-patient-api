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

        if (type == 'VariantReport')
          shipments = NciMatchPatientModels::Shipment.find_by({"molecular_id" => message[:molecular_id]})
          raise "Unable to find shipment with molecular id [#{message[:molecular_id]}]" if shipments.length == 0

          patient_id = shipments[0].patient_id
          message[:patient_id] = patient_id
          p "============ patient added: #{message}"
        end

        status = validate_patient_state_and_queue(message, type)

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

    # put /api/v1/patients/{patient_id}/variant_reports{analysis_id}/{confirm|reject}
    def variant_report_status
      begin
        p "================ confirming variant report"
        message = ConfirmVariantReportMessage.from_url get_url_path_segments
        post_data = get_post_data("")
        message['comment'] = post_data[:comment]
        message['comment_user'] = post_data[:comment_user]
        message.deep_transform_keys!(&:underscore).symbolize_keys!

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

    # PUT /api/v1/patients/{patient_id}/assignment_reports/{analysis_id}/confirm
    def assignment_confirmation
      begin

        message = ConfirmAssignmentMessage.from_url get_url_path_segments
        p "============ message from ConfirmAssignmentMessage: #{message}"
        post_data = get_post_data("")
        message['comment'] = post_data[:comment]
        message['comment_user'] = post_data[:comment_user]
        message.deep_transform_keys!(&:underscore).symbolize_keys!

        type = MessageValidator.get_message_type(message)
        raise "Incoming message has UNKNOWN message type" if (type == 'UNKNOWN')

        error = MessageValidator.validate_json_message(type, message)
        raise "Incoming message failed message schema validation: #{error}" if !error.nil?
        p "=========== input data: #{message}"

        success = validate_patient_state(message, type)
        result = PatientProcessor.run_service('/confirm_assignment', message)
        standard_success_message(result)
      rescue => error
        standard_error_message(error.message)
      end
    end

    def get_shipment
      molecular_id = params[:molecular_id]
      shipments = NciMatchPatientModels::Shipment.find_by({"molecular_id" => molecular_id}).collect { |data| data.to_h.compact }

      render :json => shipments.to_json, :status => 200
    end

  end
end

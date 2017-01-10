module V1
  class ServicesController < ApplicationController
    before_action :authenticate_user
    load_and_authorize_resource class: "NciMatchPatientModels"

    # POST /api/v1/patients/{patient_id}
    def trigger
      puts "================== current user: #{current_user.to_json}"
      patient_id = get_patient_id_from_url
      message = get_post_data(patient_id)

      type = MessageValidator.get_message_type(message)
      raise Errors::RequestForbidden, 'Incoming message has UNKNOWN message type' if (type == 'UNKNOWN')

      if (type == 'VariantReport')
        shipments = NciMatchPatientModels::Shipment.find_by({"molecular_id" => message[:molecular_id]})
        raise "Unable to find shipment with molecular id [#{message[:molecular_id]}]" if shipments.length == 0

        patient_id = shipments[0].patient_id
        message[:patient_id] = patient_id
      end

      error = MessageValidator.validate_json_message(type, message)
      raise Errors::RequestForbidden, "Incoming message failed message schema validation: #{error}" unless error.nil?

      validate_patient_state_and_queue(message, type)

      standard_success_message('Message has been processed successfully', 202)

    end

    # POST /api/v1/patients/variant_report/:molecular_id
    def variant_report_uploaded
      message = get_post_data("")

      type = MessageValidator.get_message_type(message)
      raise Errors::RequestForbidden, 'Incoming message has UNKNOWN message type' if (type == 'UNKNOWN')

      shipments = NciMatchPatientModels::Shipment.find_by({"molecular_id" => message[:molecular_id]})
      raise Errors::RequestForbidden, "Unable to find shipment with molecular id [#{message[:molecular_id]}]" if shipments.length == 0

      patient_id = shipments[0].patient_id
      message[:patient_id] = patient_id

      error = MessageValidator.validate_json_message(type, message)
      raise Errors::RequestForbidden, "Incoming message failed message schema validation: #{error}" unless error.nil?

      status = validate_patient_state_and_queue(message, type)

      raise Errors::RequestForbidden, 'Incoming message failed patient state validation' if status == false

      standard_success_message('Message has been processed successfully', 202)

    end

    # PUT /api/v1/patients/variant/{variant_uuid}{checked|unchecked}
    def variant_status

      message = ConfirmVariantMessage.from_url get_url_path_segments
      raise Errors::RequestForbidden, message if message.is_a? String

      post_data = get_post_data("")
      message['comment'] = post_data[:comment]
      message['comment_user'] = post_data[:comment_user]

      response = PatientProcessor.run_service("/confirm_variant", message, token)
      response_hash = response.parsed_response
      raise Errors::RequestForbidden, response_hash["message"] if !((200..299).include? response.code)


      AppLogger.log(self.class.name, "variant_status response from Patient Processor: #{response_hash}")
      standard_success_message(response_hash["message"])

    end

    # put /api/v1/patients/{patient_id}/variant_reports{analysis_id}/{confirm|reject}
    def variant_report_status
      message = ConfirmVariantReportMessage.from_url get_url_path_segments
      raise Errors::RequestForbidden, message if message.is_a? String

      post_data = get_post_data("")
      message['comment'] = post_data[:comment]
      message['comment_user'] = post_data[:comment_user]
      message.deep_transform_keys!(&:underscore).symbolize_keys!

      type = MessageValidator.get_message_type(message)
      raise Errors::RequestForbidden, "Incoming message has UNKNOWN message type" if type == 'UNKNOWN'

      error = MessageValidator.validate_json_message(type, message)
      raise Errors::RequestForbidden, "Incoming message failed message schema validation: #{error}" unless error.nil?

      validate_patient_state(message, type)
      result = PatientProcessor.run_service('/confirmVariantReport', message, token)
      standard_success_message(result)
    end

    # PUT /api/v1/patients/{patient_id}/assignment_reports/{analysis_id}/confirm
    def assignment_confirmation
      message = ConfirmAssignmentMessage.from_url get_url_path_segments
      raise Errors::RequestForbidden, message if message.is_a? String

      p "============ message for ConfirmAssignmentMessage: #{message}"
      post_data = get_post_data("")
      message['comment'] = post_data[:comment]
      message['comment_user'] = post_data[:comment_user]
      message.deep_transform_keys!(&:underscore).symbolize_keys!

      type = MessageValidator.get_message_type(message)
      raise Errors::RequestForbidden, "Incoming message has UNKNOWN message type" if type == 'UNKNOWN'

      error = MessageValidator.validate_json_message(type, message)
      raise Errors::RequestForbidden, "Incoming message failed message schema validation: #{error}" unless error.nil?

      validate_patient_state(message, type)
      result = PatientProcessor.run_service('/confirm_assignment', message, token)
      standard_success_message(result)
    end
  end
end

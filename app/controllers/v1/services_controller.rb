module V1
  class ServicesController < ApplicationController
    before_action :authenticate_user
    load_and_authorize_resource :class => NciMatchPatientModels


    # POST /api/v1/patients/{patient_id}
    def trigger
      puts "================== current user: #{current_user.to_json}"
      patient_id = get_patient_id_from_url
      message = ApplicationHelper.replace_value_in_patient_message(get_post_data, "patient_id", patient_id)
      message = ApplicationHelper.trim_value_in_patient_message(message)
      message.deep_symbolize_keys!

      type = MessageValidator.get_message_type(message)
      raise Errors::RequestForbidden, 'Incoming message has UNKNOWN message type' if (type == 'UNKNOWN')
      # authorize! :validate_json_message, type.to_sym
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
      message = get_post_data
      message = ApplicationHelper.trim_value_in_patient_message(message)
      message.deep_symbolize_keys!

      type = MessageValidator.get_message_type(message)
      raise Errors::RequestForbidden, 'Incoming message has UNKNOWN message type' if (type == 'UNKNOWN')

      # authorize! :validate_json_message, type.to_sym
      shipments = NciMatchPatientModels::Shipment.find_by({"molecular_id" => message[:molecular_id]})
      raise Errors::RequestForbidden, "Unable to find shipment with molecular id [#{message[:molecular_id]}]" if shipments.length == 0

      lab_type = shipments[0].destination
      authorize! :variant_report_uploaded, lab_type.to_sym

      patient_id = shipments[0].patient_id
      message[:patient_id] = patient_id

      error = MessageValidator.validate_json_message(type, message)
      raise Errors::RequestForbidden, "Incoming message failed message schema validation: #{error}" unless error.nil?

      p "================== here1"
      validate_patient_state_and_queue(message, type)

      standard_success_message('Message has been processed successfully', 202)

    end

    # PUT /api/v1/patients/variant/{variant_uuid}{checked|unchecked}
    def variant_status
      message = ConfirmVariantMessage.from_url get_url_path_segments
      raise Errors::RequestForbidden, message if message.is_a? String

      post_data = get_post_data
      message[:comment] = post_data[:comment]
      message[:comment_user] = post_data[:comment_user]

      variant = NciMatchPatientModels::Variant.query_by_uuid(message[:variant_uuid])
      raise Errors::ResourceNotFound, "Unable to find variant with uuid" if variant.nil?

      variant_report = NciMatchPatientModels::VariantReport.query_by_analysis_id(variant.patient_id, variant.analysis_id)
      raise Errors::RequestForbidden, "Variant with uuid does not belong to any variant report" if variant_report.nil?

      lab_type = variant_report.clia_lab
      authorize! :variant_report_status, lab_type.to_sym

      response = PatientProcessor.run_service("/confirm_variant", message, request.uuid, token)
      response_hash = response.parsed_response
      raise Errors::RequestForbidden, response_hash["message"] unless ((200..299).include? response.code)

      AppLogger.log(self.class.name, "variant_status response from Patient Processor: #{response_hash}")
      standard_success_message(response_hash["message"])

    end

    # put /api/v1/patients/{patient_id}/variant_reports{analysis_id}/{confirm|reject}
    def variant_report_status
      message = ConfirmVariantReportMessage.from_url get_url_path_segments

      post_data = get_post_data
      message['comment'] = post_data[:comment]
      message['comment_user'] = post_data[:comment_user]
      message.deep_transform_keys!(&:underscore).symbolize_keys!

      type = MessageValidator.get_message_type(message)
      raise Errors::RequestForbidden, "Incoming message has UNKNOWN message type" if type == 'UNKNOWN'

      authorize! :validate_json_message, type.to_sym
      error = MessageValidator.validate_json_message(type, message)
      raise Errors::RequestForbidden, "Incoming message failed message schema validation: #{error}" unless error.nil?

      variant_report = NciMatchPatientModels::VariantReport.query_by_analysis_id(message[:patient_id], message[:analysis_id])
      raise Errors::RequestForbidden, "Unable to confirm non existent variant report" if variant_report.nil?

      lab_type = variant_report.to_h[:clia_lab]
      authorize! :variant_report_status, lab_type.to_sym

      validate_patient_state(message, type)
      result = PatientProcessor.run_service('/confirmVariantReport', message, request.uuid, token)
      standard_success_message(result)
    end

    # PUT /api/v1/patients/{patient_id}/assignment_reports/{analysis_id}/confirm
    def assignment_confirmation
      message = ConfirmAssignmentMessage.from_url get_url_path_segments

      p "============ message for ConfirmAssignmentMessage: #{message}"
      post_data = get_post_data
      message['comment'] = post_data[:comment]
      message['comment_user'] = post_data[:comment_user]
      message.deep_transform_keys!(&:underscore).symbolize_keys!

      type = MessageValidator.get_message_type(message)
      raise Errors::RequestForbidden, "Incoming message has UNKNOWN message type" if type == 'UNKNOWN'

      authorize! :validate_json_message, type.to_sym
      error = MessageValidator.validate_json_message(type, message)
      raise Errors::RequestForbidden, "Incoming message failed message schema validation: #{error}" unless error.nil?

      validate_patient_state(message, type)
      result = PatientProcessor.run_service('/confirm_assignment', message, request.uuid, token)
      standard_success_message(result)
    end
  end
end

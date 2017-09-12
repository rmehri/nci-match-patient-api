module V1
  class ServicesController < ApplicationController
    before_action :authenticate_user
    load_and_authorize_resource class: NciMatchPatientModels

    # POST /api/v1/patients/{patient_id}
    # TODO: remove me, i am re-routed to MessagesController
    def trigger
      logger.info("================== current user: #{current_user.to_json}")
      patient_id = get_patient_id_from_url
      message = ApplicationHelper.replace_value_in_patient_message(get_post_data, 'patient_id', patient_id)
      message = ApplicationHelper.trim_value_in_patient_message(message)
      message.deep_symbolize_keys!

      type = MessageFactory.get_message_type(message)
      raise Errors::RequestForbidden, "Incoming message failed message schema validation: #{type.errors.messages}" unless type.valid?
      authorize! :validate_json_message, type.class
      #Needs to be moved -jv
      if type.class == VariantReportMessage
        shipments = NciMatchPatientModels::Shipment.find_by({ 'molecular_id' => message[:molecular_id] })
        raise "Unable to find shipment with molecular id [#{message[:molecular_id]}]" if shipments.length == 0

        patient_id = shipments[0].patient_id
        message[:patient_id] = patient_id
      end

      validate_patient_state_and_queue(message, type.class)
      standard_success_message('Message has been processed successfully', 202)

    end

    # POST /api/v1/patients/variant_report/:molecular_id
    def variant_report_uploaded
      message = get_post_data
      message = ApplicationHelper.trim_value_in_patient_message(message)
      message.deep_symbolize_keys!

      type = MessageFactory.get_message_type(message)
      raise Errors::RequestForbidden, "Incoming message failed message schema validation: #{type.errors.messages}" unless type.valid?

      authorize! :validate_json_message, type.class
      shipments = NciMatchPatientModels::Shipment.find_by({ 'molecular_id' => message[:molecular_id] })
      raise Errors::RequestForbidden, "Unable to find shipment with molecular id [#{message[:molecular_id]}]" if shipments.length == 0

      lab_type = shipments[0].destination
      authorize! :variant_report_uploaded, lab_type.to_sym

      patient_id = shipments[0].patient_id
      message[:patient_id] = patient_id

      validate_patient_state_and_queue(message, type.class)
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
      raise Errors::ResourceNotFound, "Variant with uuid #{message[:variant_uuid]} does not exist" if variant.nil?

      variant_report = NciMatchPatientModels::VariantReport.query_by_analysis_id(variant.patient_id, variant.analysis_id)
      raise Errors::RequestForbidden, 'Variant with uuid does not belong to any variant report' if variant_report.nil?

      lab_type = variant_report.clia_lab
      authorize! :variant_report_status, lab_type.to_sym

      response = PatientProcessor.run_service('/confirm_variant', message, request.uuid, token)
      response_hash = response.parsed_response
      raise Errors::RequestForbidden, response_hash['message'] unless (200..299).include?(response.code)

      AppLogger.log(self.class.name, "variant_status response from Patient Processor: #{response_hash}")
      standard_success_message(response_hash['message'])

    end

    # put /api/v1/patients/{patient_id}/variant_reports{analysis_id}/{confirm|reject}
    def variant_report_status
      message = ConfirmVariantReportMessage.from_url get_url_path_segments

      post_data = get_post_data
      message['comment'] = post_data[:comment]
      message['comment_user'] = post_data[:comment_user]
      message.deep_transform_keys!(&:underscore).symbolize_keys!

      type = MessageFactory.get_message_type(message)
      raise Errors::RequestForbidden, "Incoming message failed message schema validation: #{type.errors.messages}" unless type.valid?
      authorize! :validate_json_message, type.class

      variant_report = NciMatchPatientModels::VariantReport.query_by_analysis_id(message[:patient_id], message[:analysis_id])
      raise Errors::RequestForbidden, 'Unable to confirm non existent variant report' if variant_report.nil?

      lab_type = variant_report.to_h[:clia_lab]
      authorize! :variant_report_status, lab_type.to_sym

      validate_patient_state(message, type.class)
      result = PatientProcessor.run_service('/confirmVariantReport', message, request.uuid, token)
      standard_success_message(result)
    end

    # PUT /api/v1/patients/{patient_id}/assignment_reports/{analysis_id}/confirm
    def assignment_confirmation
      message = ConfirmAssignmentMessage.from_url get_url_path_segments

      logger.info("============ message for ConfirmAssignmentMessage: #{message}")
      post_data = get_post_data
      message['comment'] = post_data[:comment]
      message['comment_user'] = post_data[:comment_user]
      message.deep_transform_keys!(&:underscore).symbolize_keys!

      type = MessageFactory.get_message_type(message)
      raise Errors::RequestForbidden, "Incoming message failed message schema validation: #{type.errors.messages}" unless type.valid?
      authorize! :validate_json_message, type.class

      validate_patient_state(message, type.class)
      result = PatientProcessor.run_service('/confirm_assignment', message, request.uuid, token)

      (200..250).include?(result.code) ? standard_success_message(result) : standard_error_message(result)
    end

    # flush cache when TAs change
    # NOTE: temporally disabled
    def treatment_arms_changed
      # MemoryCache.flush_all!
      render json: { message: 'Cache flushed because of TAs change.' }
    end

    private

    def get_url_path_segments
      return request.fullpath.split('/')
    end

    def get_post_data
      json_data = JSON.parse(request.raw_post)
      logger.info "Patient Api received message: #{json_data.to_json}"
      json_data.deep_transform_keys!(&:underscore).symbolize_keys!
    end

    def get_patient_id_from_url
      parts = get_url_path_segments
      logger.info "============== url parts: #{parts}"
      index = parts.index('patients')
      patient_id = parts[index + 1]
      end_index = patient_id.index('?')
      patient_id = !end_index.nil? && end_index.to_i > 0 ? patient_id[0..end_index - 1] : patient_id

      return patient_id
    end

  end
end

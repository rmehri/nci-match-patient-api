module V1
  class MessagesController < ApplicationController

    wrap_parameters :payload # avoid clash with 'message' key in input json
    before_action :authenticate_user

    attr_accessor :message
    before_action do
      self.message = request.parameters['payload'].deep_transform_values{|v| v.is_a?(String) ? v.strip : v} # strip string values
      self.message[:patient_id] = params[:patient_id] # this is not merged with wrap_parameters
    end

    def specimen_received
      authorize! :validate_json_message, SpecimenReceivedMessage
      SpecimenReceivedMessage.from_hash(message).save!(request.uuid, token)
      standard_success_message('SpecimenReceivedMessage has been processed successfully', 202)
    end

    def specimen_shipped
      authorize! :validate_json_message, SpecimenShippedMessage
      SpecimenShippedMessage.from_hash(message).save!(request.uuid, token)
      standard_success_message('SpecimenShippedMessage has been processed successfully', 202)
    end

    def assay
      authorize! :validate_json_message, AssayMessage
      AssayMessage.from_hash(message).save!(request.uuid, token)
      standard_success_message('AssayMessage has been processed successfully', 202)
    end

    def variant_report
      authorize! :validate_json_message, VariantReportMessage
      VariantReportMessage.from_hash(message).save!(request.uuid, token)
      standard_success_message('VariantReportMessage has been processed successfully', 202)
    end

    def cog
      authorize! :validate_json_message, CogMessage
      CogMessage.from_hash(message).save!(request.uuid, token)
      standard_success_message('CogMessage has been processed successfully', 202)
    end

  end
end

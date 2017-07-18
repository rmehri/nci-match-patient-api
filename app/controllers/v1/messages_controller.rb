module V1
  class MessagesController < ApplicationController

    attr_accessor :message
    before_action{|c| self.message = request.parameters['message'].deep_transform_values(&:strip)}
    before_action :authenticate_user

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

module MessageFactory

  def self.get_message_type(message)
    case message.to_s
      when MessageValidator::SpecimenReceivedValidator.message_format
        type = MessageValidator::SpecimenReceivedValidator
      when MessageValidator::SpecimenShippedValidator.message_format
        type = MessageValidator::SpecimenShippedValidator
      when MessageValidator::AssayValidator.message_format
        type = MessageValidator::AssayValidator
      when MessageValidator::PathologyValidator.message_format
        type = MessageValidator::PathologyValidator
      when MessageValidator::AssignmentStatusValidator.message_format
        type = MessageValidator::AssignmentStatusValidator
      when MessageValidator::VariantReportStatusValidator.message_format
        type = MessageValidator::VariantReportStatusValidator
      when MessageValidator::VariantReportValidator.message_format
        type = MessageValidator::VariantReportValidator
      when MessageValidator::TreatmentArmsValidator.message_format
        type = MessageValidator::TreatmentArmsValidator
      else
        type = MessageValidator::CogValidator
    end
    return type.new.from_json(message.to_json)
  end

end
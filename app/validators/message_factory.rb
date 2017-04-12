module MessageFactory

  autoload :SpecimenReceivedValidator,     'specimen_received_validator'
  autoload :SpecimenShippedValidator,      'specimen_shipped_validator'
  autoload :CogValidator,                  'cog_validator'
  autoload :OffStudyValidator,             'off_study_validator'
  autoload :AssayValidator,                'assay_validator'
  autoload :PathologyValidator,            'pathology_validator'
  autoload :VariantReportValidator,        'variant_report_validator'
  autoload :VariantReportStatusValidator,  'variant_report_status_validator'
  autoload :TreatmentArmsValidator,        'treatment_arms_validator'
  autoload :AssignmentStatusValidator,     'assignment_status_validator'
  autoload :EventValidator,                'event_validator'
  # autoload :RegistrationValidator,         'registration_validator'
  autoload :AbstractValidator,             'abstract_validator'

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

  def self.validate_json_message(type)
      unless type.valid?
        return type.errors.messages
      end
      nil
  end

end
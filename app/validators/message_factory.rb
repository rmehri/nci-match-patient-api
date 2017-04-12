module MessageValidator

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

  class << self
    cattr_reader :schema

  end

  def self.get_message_type(message)
    case message.to_s
      when MessageValidator::SpecimenReceivedValidator.message_format
        type = MessageValidator::SpecimenReceivedValidator.new
      when MessageValidator::SpecimenShippedValidator.message_format
        type = MessageValidator::SpecimenShippedValidator.new
      when MessageValidator::AssayValidator.message_format
        type = MessageValidator::AssayValidator.new
      when MessageValidator::PathologyValidator.message_format
        type = MessageValidator::PathologyValidator.new
      when MessageValidator::AssignmentStatusValidator.message_format
        type = MessageValidator::AssignmentStatusValidator.new
      when MessageValidator::VariantReportStatusValidator.message_format
        type = MessageValidator::VariantReportStatusValidator.new
      when MessageValidator::VariantReportValidator.message_format
        type = MessageValidator::VariantReportValidator.new
      when MessageValidator::TreatmentArmsValidator.message_format
        type = MessageValidator::TreatmentArmsValidator.new
      else
        type = MessageValidator::CogValidator.new
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
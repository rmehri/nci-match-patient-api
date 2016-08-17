module MessageValidator

  autoload :SpecimenReceivedValidator,     'specimen_received_validator'
  autoload :SpecimenShippedValidator,      'specimen_shipped_validator'
  autoload :CogValidator,                  'cog_validator'
  autoload :AssayValidator,                'assay_validator'
  autoload :PathologyValidator,            'pathology_validator'
  autoload :VariantValidator,              'variant_validator'
  autoload :VariantReportStatusValidator,  'variant_report_status_validator'
  autoload :TreatmentArmsValidator,        'treatment_arms_validator'
  autoload :AssignmentStatusValidator,     'assignment_status_validator'
  autoload :RegistrationValidator,         'registration_validator'

  class << self
    cattr_reader :schema

  end

  def self.get_message_type(message)
    type = 'UNKNOWN'

    if (!message[:status].nil? && (message[:status] == 'REGISTRATION' || message[:status] == 'ON_TREATMENT_ARM'))
      type = "Cog"
    elsif (!message[:specimen_received].nil?)
      type = "SpecimenReceived"
    elsif (!message[:specimen_shipped].nil?)
      type = "SpecimenShipped"
    elsif (!message[:biomarker].nil?)
      type = "Assay"
    elsif (!message[:message].nil? && message[:message].start_with?("PATHOLOGY"))
      type = "Pathology"
    elsif (!message[:status_type].nil? && message[:status_type] == 'ASSIGNMENT')
      type = "AssignmentStatus"
    elsif (!message[:status].nil? && (message[:status] == 'CONFIRMED' || message[:status] == 'REJECTED'))
      type = "VariantReportStatus"
    elsif (!message[:analysis_id].nil?)
      type = "Variant"
    elsif (!message[:treatment_arms].nil?)
      type = "TreatmentArm"
    end

    type
  end

  def self.validate_json_message(type, message_json)
    klazz = ("MessageValidator::" + type + "Validator").constantize
    begin
      message_validation = MessageValidator::CogValidator.new.from_json(message_json.to_json)

      unless message_validation.valid?
        return message_validation.errors.messages
      end
      # JSON::Validator.validate!(klazz.schema, message_json)
      nil
    rescue => error
      error.message
    end
  end

end
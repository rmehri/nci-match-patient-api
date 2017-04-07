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
    if (!message[:specimen_received].nil?)
      type = "SpecimenReceived"
    elsif (!message[:specimen_shipped].nil?)
      type = "SpecimenShipped"
    elsif (!message[:biomarker].nil?)
      type = "Assay"
    elsif (!message[:type].nil? && message[:type] == 'PATHOLOGY_STATUS')
      type = "Pathology"
    elsif (!message[:status_type].nil? && message[:status_type] == 'ASSIGNMENT')
      type = "AssignmentStatus"
    elsif (!message[:status].nil? && (message[:status] == 'CONFIRMED' || message[:status] == 'REJECTED'))
      type = "VariantReportStatus"
    elsif (!message[:analysis_id].nil?)
      type = "VariantReport"
    elsif (!message[:treatment_arms].nil?)
      type = "TreatmentArm"
    else
      type = "Cog"
    end

    # Cog
    # MDA
    # NCH
    # MATCH

    type
  end

  def self.validate_json_message(type, message_json)
    klazz = ("MessageValidator::" + type + "Validator").constantize
    begin
      message_validation = klazz.new.from_json(message_json.to_json)
      unless message_validation.valid?
        return message_validation.errors.messages
      end
      nil
    rescue => error
      error.message
    end
  end

end
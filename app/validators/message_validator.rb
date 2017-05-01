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

end
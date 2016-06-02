class PatientUiModel

  attr_accessor :patient_id
  attr_accessor :registration_date
  attr_accessor :study_id
  attr_accessor :gender
  attr_accessor :ethnicity
  attr_accessor :races
  attr_accessor :current_step_number
  attr_accessor :current_assignment
  attr_accessor :current_status

  attr_accessor :disease
  attr_accessor :prior_drugs
  attr_accessor :documents

  attr_accessor :timeline

  attr_accessor :biopsy_variant_report_map

  attr_accessor :biopsy_selectors
  attr_accessor :biopsy

  attr_accessor :variant_report_selectors
  attr_accessor :variant_report

  attr_accessor :assignment_report

end
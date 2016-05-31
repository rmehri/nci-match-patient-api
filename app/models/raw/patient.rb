class Patient
  include Aws::Record
  include Aws::Record::RecordClassMethods
  include Aws::Record::ItemOperations::ItemOperationsClassMethods

  set_table_name "#{ENV['table_prefix']}_#{self.name.underscore}_#{Rails.env}"

  number_attr :patient_id, hash_key: true
  datetime_attr :registration_date
  string_attr :study_id
  string_attr :gender
  string_attr :ethnicity
  string_attr :races
  string_attr :current_step_number
  string_attr :current_assignment
  map_attr :diseases
  map_attr :prior_drugs
  date_attr :off_trial_date
  string_attr :current_treatment_arm
  map_attr :pending_actions
  map_attr :documents

end

class Patient
  include Aws::Record

  set_table_name "sy_#{self.name.underscore}_#{Rails.env}"

  # validates_presence_of :patient_id, :study_id, :status

  string_attr :patient_id, hash_key: true
  datetime_attr :registration_date, range_key: true

  string_attr :study_id
  string_attr :status
  float_attr :step_number
  string_attr :message

end


class PatientEvent
  include Aws::Record
  include Aws::Record::Ext

  set_table_name "#{ENV['table_prefix']}_#{self.name.underscore}_#{Rails.env}"

  string_attr :patient_id, hash_key: true
  datetime_attr :event_date, range_key: true

  string_attr :event_name
  string_attr :event_type
  string_attr :event_message

  map_attr :event_data

end
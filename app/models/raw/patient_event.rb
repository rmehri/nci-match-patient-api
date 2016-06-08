
class PatientEvent
  include Aws::Record
  include Aws::Record::Ext

  set_table_name Config::Table.name self.name.underscore

  string_attr :patient_id, hash_key: true
  datetime_attr :event_date, range_key: true

  string_attr :event_name
  string_attr :event_type
  string_attr :event_message

  map_attr :event_data

end

class Biopsy
  include Aws::Record
  include Aws::Record::Ext

  set_table_name "#{ENV['table_prefix']}_#{self.name.underscore}_#{Rails.env}"

  string_attr :patient_id, hash_key: true
  string_attr :biopsy_sequence_number, range_key: true

  datetime_attr :biopsy_received_date
  string_attr :cg_id
  datetime_attr :cg_collected_date
  string_attr :study_id
  string_attr :type
end

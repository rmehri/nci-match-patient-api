
class Biopsy
  include Aws::Record

  set_table_name "#{ENV['table_prefix']}_#{self.name.underscore}_#{Rails.env}"

  string_attr :patient_sequence_number, hash_key: true
  string_attr :biopsySequenceNumber, range_key: true

  datetime_attr :biopsyReceivedDate
  string_attr :cgId
  datetime_attr :cgCollectedDate
  string_attr :studyId
  string_attr :type
end
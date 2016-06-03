
class Specimen
  include Aws::Record
  include Aws::Record::Ext

  set_table_name "#{ENV['table_prefix']}_#{self.name.underscore}_#{Rails.env}"

  # validates_presence_of :patient_id, :study_id, :status

  string_attr :patient_id, hash_key: true
  datetime_attr :cg_collected_date, range_key: true

  string_attr :cg_id
  datetime_attr :cg_received_date
  string_attr :study_id
  string_attr :type

  string_attr :pathology_status
  datetime_attr :pathology_status_date
  string_attr :disease_status

  datetime_attr :variant_report_confirmed_date

  list_attr :assays
  list_attr :assignments
  list_attr :nucleic_acid_sendouts

end
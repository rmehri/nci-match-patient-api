class Specimen
  include Aws::Record
  include Aws::Record::Ext

  set_table_name Config::Table.name self.name.underscore

  string_attr :patient_id, hash_key: true
  datetime_attr :collected_date, range_key: true

  string_attr :specimen_id
  datetime_attr :failed_date
  string_attr :study_id
  string_attr :type

  string_attr :pathology_status
  datetime_attr :pathology_status_date
  string_attr :disease_status

  datetime_attr :variant_report_confirmed_date

  list_attr :assays
  list_attr :assignments
  list_attr :specimen_shipments
end
class Patient
  include Aws::Record

  set_table_name "#{ENV['table_prefix']}_#{self.name.underscore}_#{Rails.env}"

  # validates_presence_of :patient_id, :study_id, :status

  string_attr :patient_id, hash_key: true
  datetime_attr :registration_date, range_key: true
  string_attr :study_id
  string_attr :gender
  string_attr :ethnicity
  list_attr :races
  string_attr :current_step_number
  map_attr :current_assignment
  string_attr :current_status

  map_attr :disease
  list_attr :prior_drugs
  map_attr :documents

  if (ENV['aws_region_dynamo'] != 'localhost_test' && !self.table_exists?)
    migration = Aws::Record::TableMigration.new(self)
    migration.create!(provisioned_throughput: { read_capacity_units: 5, write_capacity_units: 5 })
    migration.wait_until_available
  end

end
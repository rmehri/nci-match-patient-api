
class PatientEvent
  include Aws::Record

  set_table_name "#{ENV['table_prefix']}_#{self.name.underscore}_#{Rails.env}"

  string_attr :patient_id, hash_key: true
  datetime_attr :event_date, range_key: true

  string_attr :event_name
  string_attr :event_type
  string_attr :event_message

  map_attr :event_data

  def self.ensure_table
    if (ENV['aws_region_dynamo'] != 'localhost_test' && !self.table_exists?)
      migration = Aws::Record::TableMigration.new(self)
      migration.create!(provisioned_throughput: { read_capacity_units: 5, write_capacity_units: 5 })
      migration.wait_until_available
    end
  end

end
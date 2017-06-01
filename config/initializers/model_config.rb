module ModelConfig

  def self.configure
    begin
      ensure_table NciMatchPatientModels::Patient
      ensure_table NciMatchPatientModels::Event
      ensure_table NciMatchPatientModels::Variant
      ensure_table NciMatchPatientModels::VariantReport
      ensure_table NciMatchPatientModels::Specimen
      ensure_table NciMatchPatientModels::Shipment
      ensure_table NciMatchPatientModels::Assignment
    rescue Aws::Errors::MissingCredentialsError => error
      p "Failed to ensure tables exists because of Credential issues"
    end

  end

  def self.ensure_table(table)
    unless table.table_exists?
      read_capacity_units =  Rails.configuration.environment.fetch('read_capacity_units').to_i
      write_capacity_units = Rails.configuration.environment.fetch('write_capacity_units').to_i

      migration = Aws::Record::TableMigration.new(table)
      migration.create!(provisioned_throughput: { read_capacity_units: read_capacity_units,
                                                  write_capacity_units: write_capacity_units })
      migration.wait_until_available
    end
  end
end

ModelConfig.configure

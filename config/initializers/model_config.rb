module ModelConfig

  def self.configure
    configure_table NciMatchPatientModels::Patient
    configure_table NciMatchPatientModels::Event
    configure_table NciMatchPatientModels::Variant
    configure_table NciMatchPatientModels::VariantReport
    configure_table NciMatchPatientModels::Specimen

    ensure_table NciMatchPatientModels::Patient
    ensure_table NciMatchPatientModels::Event
    ensure_table NciMatchPatientModels::Variant
    ensure_table NciMatchPatientModels::VariantReport
    ensure_table NciMatchPatientModels::Specimen
  end

  def self.configure_table(table)
    name = table.new.class.name.underscore
    name = name.to_s.split('/').last || ''

    table.set_table_name Config::Table.name(name)
  end

  def self.ensure_table(table)

    if (!table.table_exists? && (!Rails.env.to_s.start_with?("test")))
      read_capacity_units =  ENV['read_capacity_units'].to_i
      write_capacity_units = ENV['write_capacity_units'].to_i

      migration = Aws::Record::TableMigration.new(table)
      migration.create!(provisioned_throughput: { read_capacity_units: read_capacity_units,
                                                  write_capacity_units: write_capacity_units })
      migration.wait_until_available
    end
  end

end

ModelConfig.configure

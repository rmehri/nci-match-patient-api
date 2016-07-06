module ModelConfig

  def self.configure
    configure_table NciMatchPatientModels::Patient
    configure_table NciMatchPatientModels::PatientEvent
    configure_table NciMatchPatientModels::Variant
    configure_table NciMatchPatientModels::VariantReport
    configure_table NciMatchPatientModels::Specimen

    ensure_table NciMatchPatientModels::Patient
    ensure_table NciMatchPatientModels::PatientEvent
    ensure_table NciMatchPatientModels::Variant
    ensure_table NciMatchPatientModels::VariantReport
    ensure_table NciMatchPatientModels::Specimen
  end

  def self.configure_table(table)
    name = table.new.class.name.underscore
    name = name.to_s.split('/').last || ''

    prefix = ENV["table_prefix"]
    prefix = if (prefix.nil? || prefix.length == 0) then '' else prefix + '_' end

    table.set_table_name "#{prefix}#{name}_#{Rails.env}"
  end

  def self.ensure_table(table)
    if (!table.table_exists?)
      migration = Aws::Record::TableMigration.new(table)
      migration.create!(provisioned_throughput: { read_capacity_units: 5, write_capacity_units: 5 })
      migration.wait_until_available
    end
  end

end

ModelConfig.configure

module ModelConfig

  def self.configure
    configure_table NciMatchPatientModels::Patient
    configure_table NciMatchPatientModels::PatientEvent
    configure_table NciMatchPatientModels::Biopsy
    configure_table NciMatchPatientModels::Variant
    configure_table NciMatchPatientModels::VariantReport
  end

  def self.configure_table(table)
    table.set_table_name Config::Table.name table.new.class.name.underscore
    # p table.table_name
  end

end

ModelConfig.configure

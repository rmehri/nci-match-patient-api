module ModelConfig

  def self.configure
    configure_table NciMatchPatientModels::Patient
    configure_table NciMatchPatientModels::PatientEvent
    configure_table NciMatchPatientModels::Biopsy
    configure_table NciMatchPatientModels::Variant
    configure_table NciMatchPatientModels::VariantReport
  end

  def self.configure_table(table)
    name = table.new.class.name.underscore
    name = name.to_s.split('/').last || ''

    table.set_table_name "#{name}_#{Rails.env}"
    # table.set_table_name Config::Table.name table.new.class.name.underscore
    p table.table_name
  end

end

ModelConfig.configure

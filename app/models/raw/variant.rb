
class Variant
  include Aws::Record

  set_table_name "#{ENV['table_prefix']}_#{self.name.underscore}_#{Rails.env}"

  string_attr :molecular_id_analysis_id, hash_key: true
  string_attr :variant_id, range_key: true

  string_attr :patient_id
  string_attr :cg_id
  string_attr :variant_type

  string_attr :status
  datetime_attr :confirmed_date
  datetime_attr :rejected_date
  string_attr :comment

  string_attr :gene_name
  string_attr :chromosome
  string_attr :position

  string_attr :oncomine_variant_class
  string_attr :exon
  string_attr :function
  string_attr :reference
  string_attr :alternative
  string_attr :filter
  string_attr :protein
  string_attr :transcript
  string_attr :hgvs

  integer_attr :read_depth
  boolean_attr :rare
  float_attr :allele_frequency
  integer_attr :flow_alternative_observation
  integer_attr :flow_reference_allele_observation
  integer_attr :reference_allele_observation
  boolean_attr :inclusion
  boolean_attr :arm_specific

  def self.ensure_table
    if (ENV['aws_region_dynamo'] != 'localhost_test' && !self.table_exists?)
      migration = Aws::Record::TableMigration.new(self)
      migration.create!(provisioned_throughput: { read_capacity_units: 5, write_capacity_units: 5 })
      migration.wait_until_available
    end
  end
end

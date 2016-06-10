class Variant
  include Aws::Record
  include Aws::Record::Ext

  set_table_name Config::Table.name self.name.underscore

  string_attr :msn_analysis_id, hash_key: true
  string_attr :variant_id, range_key: true

  string_attr :patient_id
  string_attr :specimen_id
  string_attr :sample_id
  string_attr :analysis_id
  string_attr :variant_type

  string_attr :status
  datetime_attr :status_date
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
end

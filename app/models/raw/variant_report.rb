class VariantReport
  include Aws::Record
  include Aws::Record::Ext

  set_table_name Config::Table.name self.name.underscore

  string_attr :specimen_id, hash_key: true
  datetime_attr :variant_report_received_date, range_key: true

  string_attr :patient_id
  string_attr :sample_id
  string_attr :analysis_id
  string_attr :status
  datetime_attr :status_date

  string_attr :comment

  string_attr :dna_bam_file_path
  string_attr :dna_bai_file_path
  string_attr :rna_bam_file_path
  string_attr :rna_bai_file_path
  string_attr :vcf_path

  integer_attr :total_variants
  integer_attr :cellularity
  integer_attr :total_mois
  integer_attr :total_amois
  integer_attr :total_confirmed_mois
  integer_attr :total_confirmed_amois
end
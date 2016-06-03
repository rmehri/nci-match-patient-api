
class VariantReport
  include Aws::Record
  include Aws::Record::Ext

  set_table_name "#{ENV['table_prefix']}_#{self.name.underscore}_#{Rails.env}"

  string_attr :cg_id, hash_key: true
  datetime_attr :variant_report_received_date, range_key: true

  string_attr :patient_id
  string_attr :molecular_id
  string_attr :analysis_id
  string_attr :status

  datetime_attr :confirmed_date
  datetime_attr :rejected_date

  string_attr :dna_bam_file_path
  string_attr :dna_bai_file_path
  string_attr :rna_bam_file_path
  string_attr :rna_bai_file_path
  string_attr :vcf_path

  def self.ensure_table
    if (ENV['aws_region_dynamo'] != 'localhost_test' && !self.table_exists?)
      migration = Aws::Record::TableMigration.new(self)
      migration.create!(provisioned_throughput: { read_capacity_units: 5, write_capacity_units: 5 })
      migration.wait_until_available
    end
  end
end
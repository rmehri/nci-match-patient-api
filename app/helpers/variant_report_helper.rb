module VariantReportHelper

  def self.add_download_links(variant_report)
    return if variant_report.blank?
    variant_report.deep_symbolize_keys!

    s3_file_folder = "#{variant_report[:ion_reporter_id]}/#{variant_report[:molecular_id]}/#{variant_report[:analysis_id]}/"
    files = Aws::S3::S3Reader.get_file_set(Rails.configuration.environment.fetch('s3_bucket'), s3_file_folder)

    add_vcf_link(variant_report, files)
    add_bam_links(variant_report, files)
    add_bai_links(variant_report, files)

    variant_report
  end

  def self.add_bai_links(variant_report, files)
    targets = files.select { |f| f[:file_path_name].end_with? ".bai"}
    return if targets.length == 0

    targets = targets.sort_by{|target| target[:size]}
    variant_report[:dna_bai_path_name] = targets[0][:file_path_name]
    variant_report[:rna_bai_path_name] = targets[1][:file_path_name] if targets.length > 1
  end

  def self.add_bam_links(variant_report, files)
    targets = files.select { |f| f[:file_path_name].end_with? ".bam"}
    return if targets.length == 0

    targets = targets.sort_by{|target| target[:size]}
    variant_report[:dna_bam_path_name] = targets[0][:file_path_name]
    variant_report[:rna_bam_path_name] = targets[1][:file_path_name] if targets.length > 1
  end

  def self.add_vcf_link(variant_report, files)

    targets = files.select { |f| f[:file_path_name].end_with? ".vcf"}
    return if targets.length == 0
    variant_report[:vcf_path_name] = targets[0][:file_path_name]
  end

end
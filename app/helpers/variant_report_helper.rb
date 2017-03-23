module VariantReportHelper

  def self.add_download_links(variant_report)
    return if variant_report.blank?
    variant_report.deep_symbolize_keys!

    s3_file_folder = "#{variant_report[:ion_reporter_id]}/#{variant_report[:molecular_id]}/#{variant_report[:analysis_id]}/"
    files = Aws::S3::S3Reader.get_file_set(Rails.configuration.environment.fetch('s3_bucket'), s3_file_folder)

    variant_report[:dna_bam_path_name] = find_file_link(files, variant_report[:dna_bam_name]) unless variant_report[:dna_bam_name].blank?
    variant_report[:rna_bam_path_name] = find_file_link(files, variant_report[:cdna_bam_name]) unless variant_report[:cdna_bam_name].blank?
    variant_report[:vcf_path_name] = find_file_link(files, variant_report[:vcf_file_name]) unless variant_report[:vcf_file_name].blank?

    dna_bai_name = variant_report[:dna_bam_name].blank? ? "" : s3_file_folder + construct_bai_file_name(variant_report[:dna_bam_name])
    variant_report[:dna_bai_path_name] = dna_bai_name if file_exists(files, dna_bai_name)

    rna_bai_name = variant_report[:cdna_bam_name].blank? ? "" : s3_file_folder + construct_bai_file_name(variant_report[:cdna_bam_name])
    variant_report[:rna_bai_path_name] = rna_bai_name if file_exists(files, rna_bai_name)

    variant_report[:pdf_url] = find_pdf_link(files)

    variant_report
  end

  def self.file_exists(files, bai_key)
    return false if bai_key.blank?
    target = files.select{ | file | file[:file_path_name].include? "/#{bai_key}" }
    return !(target.blank?)
  end

  def self.find_pdf_link(files)
    target = files.select{ | file | file[:file_path_name].include? ".pdf" }
    return target.blank? ? nil : target.first[:file_path_name]
  end

  def self.find_file_link(files, file_name)
    target = files.select{ | file | file[:file_path_name].include? "/#{file_name}" }
    return target.first[:file_path_name]
  end

  def self.construct_bai_file_name(bam_file_name)
    base_name = File.basename(bam_file_name, ".bam")
    base_name + ".bai"
  end

end
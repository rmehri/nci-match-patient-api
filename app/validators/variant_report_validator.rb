module MessageValidator
  class VariantReportValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks

    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :site,
                  :molecular_id,
                  :analysis_id,
                  :tsv_file_name,
                  :vcf_file_name,
                  :dna_bam_file_name,
                  :cdna_bam_file_name,
                  :dna_bai_file_name,
                  :cdna_bai_file_path_name


    validates :site, presence: true
    validates :molecular_id, presence: true
    validates :analysis_id, presence: true

    # validates :tsv_file_name, allow_nil: true, if (!:dna_bam_file_name.nil? || !:cdna_bam_file_name.nil?)


    # validates :tsv_file_path_name, presence: true
    # validates :vcf_file_path_name, presence: true
    # validates :dna_bam_file_path_name, presence: true
    # validates :cdna_bam_file_path_name, presence: true

  end
end
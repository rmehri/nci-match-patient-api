module MessageValidator
  class EventValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks


    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :patient_id, :molecular_id, :analysis_id, :surgical_event_id, :dna_file_name, :rna_file_name, :vcf_file_name

    validates :molecular_id, presence: true
    validates :analysis_id, presence: true
    validates :dna_file_name, file: [".bam"]
    validates :rna_file_name, file: [".bam"]
    validates :vcf_file_name, file: [".vcf", ".zip"]
  end
end
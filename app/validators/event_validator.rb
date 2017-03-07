module MessageValidator
  class EventValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks


    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :patient_id, :molecular_id, :analysis_id, :surgical_event_id, :dna_bam_name, :cdna_bam_name, :zip_name

    validates :molecular_id, presence: true
    validates :analysis_id, presence: true
    validates :dna_bam_name, file: [".bam"]
    validates :cdna_bam_name, file: [".bam"]
    validates :zip_name, file: [".vcf", ".zip"]
  end
end
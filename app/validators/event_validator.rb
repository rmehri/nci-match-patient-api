module MessageValidator
  module EventValidator
    extend ActiveSupport::Concern

    included do
      validates :molecular_id, presence: true
      validates :analysis_id, presence: true
      validates :dna_bam_name, file: [".bam"]
      validates :cdna_bam_name, file: [".bam"]
      validates :zip_name, file: [".vcf", ".zip"]
    end

  end
end
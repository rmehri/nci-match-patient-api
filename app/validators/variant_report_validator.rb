module MessageValidator
  module VariantReportValidator
    extend ActiveSupport::Concern

    included do
      validates :ion_reporter_id, presence: true
      validates :molecular_id, presence: true
      validates :analysis_id, presence: true
      validates :tsv_file_name, presence: true
    end

  end
end
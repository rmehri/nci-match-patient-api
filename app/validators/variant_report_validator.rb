module MessageValidator
  class VariantReportValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks

    @message_format =/:analysis_id/

    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :ion_reporter_id,
                  :patient_id,
                  :molecular_id,
                  :analysis_id,
                  :tsv_file_name

    validates :ion_reporter_id, presence: true
    validates :molecular_id, presence: true
    validates :analysis_id, presence: true
    validates :tsv_file_name, presence: true
    validates :patient_id, presence: true

  end
end
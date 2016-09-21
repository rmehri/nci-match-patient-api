module MessageValidator
  class VariantReportValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks

    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :ir_id,
                  :molecular_id,
                  :analysis_id,
                  :tsv_file_name,

    validates :ir_id, presence: true
    validates :molecular_id, presence: true
    validates :analysis_id, presence: true
    validates :tsv_file_name, presence: true

  end
end
module MessageValidator
  class TreatmentArmsValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks

    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :treatment_arms

    validates :treatment_arms, presence: true

  end
end

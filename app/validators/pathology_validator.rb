module MessageValidator
  class PathologyValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks

    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :patient_id, :surgical_event_id, :status, :reported_date, :message

    validates :patient_id, presence: true
    validates :surgical_event_id, presence: true

    validates :reported_date, presence: true
    validates :status, presence: true, inclusion: {in: %w(Y N U), message: "%{value} is not a valid pathology review status"}

  end
end
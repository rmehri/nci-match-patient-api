module MessageValidator
  class EventValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks


    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :entity_id, :event_date, :event_data, :event_message, :event_type

    validates :entity_id, presence: true
    validates :event_date, presence: true
  end
end
module MessageValidator
  class RegistrationValidator < AbstractValidator
    include ActiveModel::Serializers::JSON
    include ActiveModel::Validations

    attr_accessor :header, :study_id, :patient_id, :step_number, :registration_date, :status, :internal_use_only

    validates :header, presence: true
    validates :study_id, presence: true, inclusion: { in: %w(APEC1621), message: "%{value} is not a valid study_id"}
    validates :patient_id, presence: true
    validates :step_number, presence: true, numericality: { equal_to: 1.0 }
    validates :registration_date, presence: true, date: {on_or_before: Date.current}
    validates :status, presence: true, inclusion: { in: %w(REGISTRATION), message: "%{value} is not supported by a REGISTRATION message"}
    validates :internal_use_only, presence: true

  end
end


module RegistrationValidator
  extend ActiveSupport::Concern

  included do
    validates :step_number, presence: true, numericality: { equal_to: 1.0, message: "Step value must be 1.0 for patient registration" }
    validates :registration_date, presence: true, date: { on_or_before: lambda {DateTime.current.utc}, message: "registration_date can not be later than current date"}
    validates :status, presence: true, inclusion: { in: %w(REGISTRATION), message: "%{value} is not supported by a REGISTRATION message"}
    validates :internal_use_only, presence: true
  end

end
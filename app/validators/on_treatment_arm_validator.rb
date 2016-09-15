
module OnTreatmentArmValidator
  extend ActiveSupport::Concern

  included do
    validates :status, presence: true, inclusion: { in: %w(ON_TREATMENT_ARM), message: "%{value} is not supported by a ON_TREATMENT_ARM message"}
    validates :treatment_arm_id, presence: true
    validates :stratum_id, presence: true
    validates :internal_use_only, presence: true
    validates :step_number, presence: true
  end
end
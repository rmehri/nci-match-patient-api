
module OnTreatmentArmValidator
  extend ActiveSupport::Concern

  included do
    validates :treatment_arm_id, presence: true
    validates :stratum_id, presence: true
    validates :internal_use_only, presence: true
    validates :step_number, presence: true
  end
end
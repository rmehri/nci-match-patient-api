
module OnTreatmentArmValidator
  extend ActiveSupport::Concern

  included do
    validates :header, presence: true
    validates :study_id, presence: true, inclusion: { in: %w(APEC1621), message: "%{value} is not a valid study_id"}
    validates :patient_id, presence: true
    validates :step_number, presence: true
    validates :status, presence: true
    validates :treatment_arm_id, presence: true
    validates :treatment_arm_version, presence: true
    validates :stratum_id, presence: true
    validates :internal_use_only, presence: true
  end
end
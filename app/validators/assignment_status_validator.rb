module MessageValidator
  module AssignmentStatusValidator
    extend ActiveSupport::Concern

    included do
      validates :patient_id, presence: true
      validates :analysis_id, presence: true
      validates :status, presence: true,
                inclusion: {in: %w(CONFIRMED), message: "%{value} is not a valid assignment status value"}
      validates :status_type, presence: true,
                inclusion: {in: %w(ASSIGNMENT), message: "%{value} is not a valid status type value"}
    end
  end
end

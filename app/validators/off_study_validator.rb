module OffStudyValidator
  extend ActiveSupport::Concern

  included do
    validates :status, presence: true, inclusion: { in: %w(OFF_STUDY OFF_STUDY_BIOPSY_EXPIRED), message: "%{value} is not supported by a OFF_STUDY message"}
    validates :internal_use_only, presence: true
    validates :step_number, presence: true
  end

end
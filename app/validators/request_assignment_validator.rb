module RequestAssignmentValidator
  extend ActiveSupport::Concern

  included do

    validates :internal_use_only, presence: true
    validates :step_number, presence: true
    validates :status_date, presence: true
  end
end
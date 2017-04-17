module OffStudyValidator
  extend ActiveSupport::Concern

  included do
    validates :status, presence: true, inclusion: { in: %w(OFF_STUDY OFF_STUDY_BIOPSY_EXPIRED), message: "%{value} is not supported by a OFF_STUDY message"}
    # validates :status_date, presence: true, date: { on_or_before: lambda {DateTime.current.utc}, message: "status_date can not be later than current date"}
    validates :status_date, presence: true, inclusion: {in: ((Time.now.utc - 5.years)..Time.now.utc), message: "status_date can not be later than current date"}
    validates :internal_use_only, presence: true
    validates :step_number, presence: true
  end

end
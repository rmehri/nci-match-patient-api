module MessageValidator
  module AssayValidator
    extend ActiveSupport::Concern

    included do
      validates :study_id, presence: true, inclusion: { in: %w(APEC1621SC), message: "%{value} is not a valid study_id" } # reapeated so should be its own validation
      validates :patient_id, presence: true
      validates :surgical_event_id, presence: true
      validates :result, presence: true, inclusion: {in: %w(POSITIVE NEGATIVE INDETERMINATE), message: "%{value} is not a valid assay result"}
      validates :case_number, presence: true
      validates :type, inclusion: {in: %w(RESULT), message: "%{value} is not a valid assay message type"}
    end

  end
end
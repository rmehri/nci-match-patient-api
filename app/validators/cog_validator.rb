module MessageValidator
  module CogValidator
    extend ActiveSupport::Concern

    included do
      validates :header, presence: true
      validates :study_id, presence: true, inclusion: { in: %w(APEC1621SC), message: "%{value} is not a valid study_id"}
      validates :patient_id, presence: true
      validates :status, presence: true, inclusion: { in: %w(REGISTRATION ON_TREATMENT_ARM REQUEST_ASSIGNMENT REQUEST_NO_ASSIGNMENT OFF_STUDY OFF_STUDY_BIOPSY_EXPIRED),
                                                      message: "%{value} is not supported COG status value"}
    end

  end
end

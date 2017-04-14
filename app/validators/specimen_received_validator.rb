module MessageValidator
  module SpecimenReceivedValidator
    extend ActiveSupport::Concern

    included do
      validates :header, presence: true
      validates :study_id, presence: true, inclusion: { in: %w(APEC1621SC), message: "%{value} is not a valid study_id"} # reapeated so should be its own validation
      validates :patient_id, presence: true
      validates :type, presence: true, inclusion: {in: %w(BLOOD TISSUE), message: "%{value} is not a support type"}
      validates :collected_date, presence: true
      validates :received_date, presence: true
      validates :internal_use_only, presence: true
    end

  end
end
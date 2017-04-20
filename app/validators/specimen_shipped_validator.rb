module MessageValidator
  module SpecimenShippedValidator
    extend ActiveSupport::Concern

    included do
      validates :header, presence: true
      validates :study_id, presence: true, inclusion: { in: %w(APEC1621SC), message: "%{value} is not a valid study_id"} # reapeated so should be its own validation
      validates :patient_id, presence: true
      validates :type, presence: true, inclusion: {in: %w(TISSUE_DNA_AND_CDNA SLIDE BLOOD_DNA), message: "%{value} is not a support type"}
      validates :carrier, presence: true
      validates :tracking_id, presence: true
      validates :destination, presence: true, inclusion: {in: %w(MDA MoCha Dartmouth), message: "%{value} is not a valid shipping destination"}
      validates :internal_use_only, presence: true
    end

  end
end
module BloodSpecimenShippedValidator
  extend ActiveSupport::Concern

  included do
    validates :molecular_id, presence: true
    validates_absence_of :surgical_event_id
  end

end
module BloodSpecimenShippedValidator
  extend ActiveSupport::Concern

  included do
    validates :molecular_id, presence: true
  end

end
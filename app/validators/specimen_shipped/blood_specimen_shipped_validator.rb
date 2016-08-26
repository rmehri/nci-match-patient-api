module BloodSpecimenShippedValidator
  extend ActiveSupport::Concern

  included do
    validates :molecular_id, presence: true
    validates :shipped_dttm, presence: true, date: {on_or_before: DateTime.current.utc}
  end

end
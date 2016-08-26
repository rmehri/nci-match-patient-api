module TissueSpecimenShippedValidator
  extend ActiveSupport::Concern

  included do
    validates :surgical_event_id, presence: true
    validates :molecular_id, presence: true
    validates :molecular_dna_id, presence: true
    validates :molecular_cdna_id, presence: true
    validates :shipped_dttm, presence: true, date: {on_or_before: DateTime.current.utc}
  end

end
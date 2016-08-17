module SlideSpecimenShippedValidator
  extend ActiveSupport::Concern

  included do
    validates :slide_barcode, presence: true
    validates :surgical_event_id, presence: true
  end

end
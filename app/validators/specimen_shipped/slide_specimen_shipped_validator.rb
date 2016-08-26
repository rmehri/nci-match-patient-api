module SlideSpecimenShippedValidator
  extend ActiveSupport::Concern

  included do
    validates :slide_barcode, presence: true
    validates :surgical_event_id, presence: true
    validates :destination, presence: true, inclusion: {in: %w(MDA), message: "%{value} is not a valid shipping destination for SLIDE"}
  end

end
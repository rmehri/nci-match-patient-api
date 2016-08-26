module SlideSpecimenShippedValidator
  extend ActiveSupport::Concern

  included do
    validates :slide_barcode, presence: true
    validates :surgical_event_id, presence: true
    validates :destination, presence: true, inclusion: {in: %w(MDA), message: "%{value} is not a valid shipping destination for SLIDE"}
    validates :shipped_dttm, presence: true, date: {on_or_before: DateTime.current.utc}
  end

end
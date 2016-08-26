
module TissueSpecimenReceivedValidator
  extend ActiveSupport::Concern

  included do
    validates :surgical_event_id, presence: true
    validates :collected_date, presence: true, date: {on_or_before: DateTime.current.utc}
    validates :received_date, presence: true, date: {on_or_before: DateTime.current.utc}
  end


end
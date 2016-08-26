
module BloodSpecimenReceivedValidator
  extend ActiveSupport::Concern

  included do
    #Place holder incase we ever have a unique validation for blood
    validates :collected_date, presence: true, date: {on_or_before: DateTime.current.utc}
    validates :received_date, presence: true, date: {on_or_before: DateTime.current.utc}
  end


end
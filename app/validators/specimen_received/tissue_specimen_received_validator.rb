
module TissueSpecimenReceivedValidator
  extend ActiveSupport::Concern

  included do
    validates :surgical_event_id, presence: true
  end


end
module MessageValidator
  module PathologyValidator
    extend ActiveSupport::Concern

    included do
      validates :patient_id, presence: true
      validates :study_id, presence: true, inclusion: { in: %w(APEC1621SC), message: "%{value} is not a valid study_id"}
      validates :surgical_event_id, presence: true
      validates :status, presence: true, inclusion: {in: %w(Y N U), message: "%{value} is not a valid pathology review status"}
      validates :case_number, presence: true
      validates :type, inclusion: {in: %w(PATHOLOGY_STATUS), message: "%{value} is not a valid pathology message type"}
    end

  end

end
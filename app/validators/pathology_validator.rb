module MessageValidator
  class PathologyValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks

    @message_format = /:type=>"PATHOLOGY_STATUS"/

    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :patient_id, :study_id, :surgical_event_id, :status, :reported_date,
                  :case_number, :type

    validates :patient_id, presence: true
    validates :study_id, presence: true, inclusion: { in: %w(APEC1621SC), message: "%{value} is not a valid study_id"}
    validates :surgical_event_id, presence: true
    validates :reported_date, presence: true, date: {on_or_before: lambda {DateTime.current.utc}}
    validates :status, presence: true, inclusion: {in: %w(Y N U), message: "%{value} is not a valid pathology review status"}
    validates :case_number, presence: true
    validates :type, inclusion: {in: %w(PATHOLOGY_STATUS), message: "%{value} is not a valid pathology message type"}
  end

end
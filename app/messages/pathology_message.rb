
class PathologyMessage < AbstractMessage
  include MessageValidator::PathologyValidator

  @message_format = /:type=>"PATHOLOGY_STATUS"/

  attr_accessor :patient_id, :study_id, :surgical_event_id, :status, :reported_date,
                :case_number, :type

  validates :reported_date, presence: true, date: {on_or_before: lambda {DateTime.current.utc}}

end
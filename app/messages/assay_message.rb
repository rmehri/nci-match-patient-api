class AssayMessage < AbstractMessage
  include MessageValidator::AssayValidator

  @message_format = /:biomarker/
  attr_accessor :study_id, :patient_id, :surgical_event_id, :biomarker, :reported_date, :result,
                :case_number, :type

  validates :biomarker, presence: true, inclusion: {in: Rails.configuration.assay.collect{ |k, v| if(Date.parse(v["start_date"]) <= Date.current) && (Date.current <= Date.parse(v["end_date"])); k; end},
                                                    message: "%{value} is not a valid biomarker"}
  validates :reported_date, presence: true, date: {on_or_before: lambda {DateTime.current.utc}}


end
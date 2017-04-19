class AssayMessage < AbstractMessage
  include MessageValidator::AssayValidator

  @message_format = /:biomarker/
  attr_accessor :study_id, :patient_id, :surgical_event_id, :biomarker, :reported_date, :result,
                :case_number, :type

  def reported_date=(value)
    @reported_date = DateTime.parse(value)
  end

end
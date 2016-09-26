
class ConfirmVariantReportMessage
  def self.from_url(url_segments)
    start_index = url_segments.index("patients")
    raise "Confirm variant report url is missing patient id" if url_segments.length < start_index + 1

    patient_id = url_segments[start_index+1]

    start_index = url_segments.index("variant_reports")
    raise "Confirm variant report url is missing parameter" if url_segments.length < start_index + 2

    analysis_id = url_segments[start_index+1]
    confirm = url_segments[start_index+2].downcase
    confirm = confirm == 'confirm' ? 'CONFIRMED' : 'REJECTED'

    {"patient_id" => patient_id, "analysis_id" => analysis_id, "status" => confirm}
  end

end
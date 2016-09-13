
class ConfirmVariantReportMessage
  def self.from_url(url_segments)
    start_index = url_segments.index("patients")
    raise "Confirm variant report url is missing patient id" if url_segments.length < start_index + 1

    patient_id = url_segments[start_index+1]

    start_index = url_segments.index("variant_reports")
    raise "Confirm variant report url is missing parameter" if url_segments.length < start_index + 3

    molecular_id = url_segments[start_index+1]
    analysis_id = url_segments[start_index+2]

    confirm = url_segments[start_index+3].downcase
    if confirm == 'confirm'
      confirm = 'CONFIRMED'
    elsif confirm == 'reject'
      confirm = 'REJECTED'
    else
      raise "Unrecognized confirm|reject flag passed in confirm variant report url"
    end

    message = {"patient_id" => patient_id, "molecular_id" => molecular_id, "analysis_id" => analysis_id, "status" => confirm}
  end

end
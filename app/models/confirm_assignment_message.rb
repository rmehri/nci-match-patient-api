
class ConfirmAssignmentMessage
  def self.from_url(url_segments)
    raise ActionController::BadRequest unless url_segments.is_a? Array
    {"patient_id" => url_segments[4], "analysis_id" => url_segments[6],
               "status" => (url_segments[7]+ 'ed').upcase, "status_type" => "ASSIGNMENT"}
  end
end
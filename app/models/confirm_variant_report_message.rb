
class ConfirmVariantReportMessage
  def self.from_url(url_segments)
    raise ActionController::BadRequest.new("Malformed URL") unless url_segments.is_a? Array
    {"patient_id" => url_segments[4], "analysis_id" => url_segments[6], "status" => (url_segments.last + 'ED').upcase} rescue raise ActionController::BadRequest.new("Url is malformed")
  end

end
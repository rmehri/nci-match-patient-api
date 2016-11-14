
class ConfirmAssignmentMessage
  def self.from_url(url_segments)

    puts "url_segments: #{url_segments}"

    start_index = url_segments.index("patients")
    raise "Assignment reports url is missing patient id" if url_segments.length < start_index + 1

    patient_id = url_segments[start_index+1]

    start_index = url_segments.index("assignment_reports")
    raise "Assignment reports url is missing parameter" if url_segments.length < start_index + 2

    analysis_id = url_segments[start_index+1]
    confirm = url_segments[start_index+2].downcase

    raise "Unregnized confirm flag in assignment report confirmation url" if (confirm != 'confirm')

    message = {"patient_id" => patient_id, "analysis_id" => analysis_id,
               "status" => "CONFIRMED", "status_type" => "ASSIGNMENT"}

  end
end
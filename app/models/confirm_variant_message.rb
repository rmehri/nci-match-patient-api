class ConfirmVariantMessage

  attr_accessor :id, :patient_id, :molecular_id, :analysis_id,
                :type, :status, :comment, :comment_user

  def self.from_json(string)
    data = JSON.load string
    created = self.new

    created.id = data['id']
    created.patient_id = data['patient_id']
    created.molecular_id = data['molecular_id']
    created.analysis_id = data['analysis_id']
    created.type = data['type']
    created.status = data['status']
    created.comment = data['comment']
    created.comment_user = data['comment_user']

    return created
  end

  def self.from_url(url_segments)
    raise ActionController::BadRequest unless url_segments.is_a? Array
    url_segments.last.downcase!
    raise "Unregnized checked flag in variant confirmation url" unless (url_segments.include?("unchecked") || url_segments.include?("checked"))
    {:variant_uuid => url_segments[5], :status => url_segments.last}
  end
end

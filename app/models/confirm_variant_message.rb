class ConfirmVariantMessage

  attr_accessor :id
  attr_accessor :patient_id
  attr_accessor :molecular_id
  attr_accessor :analysis_id
  attr_accessor :type
  attr_accessor :status
  attr_accessor :comment
  attr_accessor :comment_user

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
    start_index = url_segments.index("variant")
    raise "Variant confirmation url has missing parameter" if url_segments.length < start_index + 3

    id = url_segments[start_index+1]
    comment = url_segments[start_index+2]
    check = url_segments[start_index+3].downcase

    raise "Unregnized checked flag in variant confirmation url" if (check != 'checked' && check != 'unchecked')

    message = {"variant_uuid" => id, "comment" => comment, "status" => check}

  end

end

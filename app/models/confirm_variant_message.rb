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
    start_index = url_segments.index('variant')
    raise 'Variant confirmation url has missing parameter' if url_segments.length < start_index + 2

    id = url_segments[start_index + 1]
    check = url_segments[start_index + 2].downcase

    # raise "Unregnized checked flag in variant confirmation url" if (check != 'checked' && check != 'unchecked')

    message = (check != 'checked' && check != 'unchecked') ? 'Unregnized checked flag in variant confirmation url' : { variant_uuid: id, status: check }
  end
end

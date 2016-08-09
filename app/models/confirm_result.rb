class ConfirmResult

  attr_accessor :id
  attr_accessor :patient_id
  attr_accessor :molecular_id
  attr_accessor :type
  attr_accessor :confirmed
  attr_accessor :comment
  attr_accessor :comment_user

  def self.from_json(string)
    data = JSON.load string
    created = self.new

    created.id = data['id']
    created.patient_id = data['patient_id']
    created.molecular_id = data['molecular_id']
    created.type = data['type']
    created.confirmed = data['confirmed']
    created.comment = data['comment']
    created.comment_user = data['comment_user']

    return created
  end

end

class ConfirmResult

  attr_accessor :confirmed
  attr_accessor :comments

  def self.from_json(string)
    data = JSON.load string
    created = self.new

    created.confirmed = data['confirmed']
    created.comments = data['comments']

    return created
  end

end

class ConfirmResult
  include ActiveModel::Serializers::JSON
  include ActiveModel::Validations

  attr_accessor :confirmed
  attr_accessor :comments

end

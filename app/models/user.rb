class User
  include Aws::Record
  include ActiveModel::SecurePassword

  set_table_name Config::Table.name self.name.underscore

  has_secure_password

  string_attr :id, hash_key: true
  string_attr :password

  def self.from_token_payload payload
    self.find(id: payload['sub'])
  end

end
class User
  include ActiveModel::SecurePassword
  has_secure_password

  def self.from_token_payload payload

    puts "========== payload: #{payload}"

    payload.blank? ? false : payload
  end

end
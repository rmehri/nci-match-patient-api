class User
  include ActiveModel::SecurePassword
  has_secure_password

  def self.from_token_payload payload
    return false if payload.blank? || payload.values_at(:roles, :sub, :email).include?(nil)
    payload.deep_symbolize_keys!
    payload
  end

end
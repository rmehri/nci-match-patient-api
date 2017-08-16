class Auth0Service
  include HTTParty

  def self.get_management_token
    options = {
        body: {
            'grant_type' => "client_credentials",
            'client_id' => Rails.application.secrets.auth0_management_id,
            'client_secret' => Rails.application.secrets.auth0_management_secret,
            'audience' => "#{Rails.configuration.environment.fetch('auth0_domain')}/api/v2/"
        }.to_json,
        headers: {'Content-Type' => 'application/json'}
    }
    response = post("#{Rails.configuration.environment.fetch('auth0_domain')}/oauth/token", options)
    management_token = JSON.parse(response.body)['access_token']
  end

  def self.update_password(user_id, password)
    options = {
        body: {'password' => password, 'connection' => Rails.configuration.environment.fetch('auth0_connection')}.to_json,
        headers: {'Content-Type' => 'application/json', 'Authorization' => "Bearer #{Auth0Service.get_management_token}"}
    }
    response = patch(URI.encode("#{Rails.configuration.environment.fetch('auth0_domain')}/api/v2/users/#{user_id}"), options)
  end
end

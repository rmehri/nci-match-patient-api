class StateMachine
  include HTTParty
  base_uri "#{Rails.configuration.environment.fetch('patient_state_api')}"

  def self.validate(message, uuid, token = "")
    begin
      result = post("/patientMessage",
                    {
                        :body => message.to_json,
                        :headers => { 'X-Request-Id' => uuid, 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
                    })
      result.body
    rescue Error => error
      AppLogger.log(self.class.name, "Exception while calling State Api /patientMessage")
      raise error
    end
  end

end

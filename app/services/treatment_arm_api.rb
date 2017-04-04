
class TreatmentArmApi
  include HTTParty

  base_uri Rails.configuration.environment["treatment_arm_api"]

  def self.get_treatment_arms(uuid, token = "")
    AppLogger.log(self.class.name, "Getting updated treatment arms from Treatment Arm Api...")

    begin
      url = base_uri + "?active=true"
      AppLogger.log(self.class.name, "Calling Treatment Arm Api: #{url}")

      response = get(url, {:headers => { 'X-Request-Id' => uuid, 'Authorization' => "Bearer #{token}"}})
      raise "Treatment Arm Api returns error #{response.code}" if response.code != 200

      response.body
    rescue Error => error
      AppLogger.log(self.class.name, "Got exception from Treatment Arm Api: #{error.message}")
      raise error
    end
  end
end
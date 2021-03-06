
class PatientProcessor
  include HTTParty
  base_uri "#{Rails.configuration.environment.fetch('patient_processor')}"

  def self.run_service(service, message, uuid, token = "")

    AppLogger.log(self.class.name, "Calling patient processor service: #{service} with message: #{message}")
    begin
      post(service,
                {
                    :body => message.to_json,
                    :headers => { 'X-Request-Id' => uuid, 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
                })
      # raise "Patient processor returned error code #{result.code}" if result.code != 200
      # result.body
    rescue Error => error
      AppLogger.log_error(self.class.name, "Exception while calling Patient Processor #{service}: #{error.message}")
      raise error
    end
  end
end
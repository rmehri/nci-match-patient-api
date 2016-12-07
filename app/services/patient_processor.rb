
class PatientProcessor
  include HTTParty
  base_uri "#{Rails.configuration.environment.fetch('patient_processor')}"

  def self.run_service(service, message, token = "")

    p "======== Calling patient processor service: #{service} with message: #{message}"
    begin
      result = post(service,
                    {
                        :body => message.to_json,
                        :headers => { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
                    })
      raise "Patient processor returned error code #{result.code}" if result.code != 200
      result.body
    rescue Error => error
      AppLogger.log_error(self.class.name, "Exception while calling Patient Processor #{service}: #{error.message}")
      raise error
    end
  end
end
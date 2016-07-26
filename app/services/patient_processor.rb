
class PatientProcessor
  include HTTParty
  base_uri "#{ENV['patient_processor']}"

  def self.run_service(service, message)
    begin
      result = post(service,
                    {
                        :body => message.to_json,
                        :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
                    })
      result.body
    rescue Error => error
      AppLogger.log_error(self.class.name, "Exception while calling Patient Processor #{service}: #{error.message}")
      raise error
    end
  end
end
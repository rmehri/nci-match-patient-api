
class PatientProcessor
  include HTTParty
  base_uri 'localhost:10242'

  def self.validate(message)
    begin
      result = post("/patientMessage",
                    {
                        :body => message.to_json,
                        :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
                    })
      result.body
    rescue Error => error
      AppLogger.log(self.class.name, "Exception while calling State Api /patientMessage")
      raise error
    end
  end
end
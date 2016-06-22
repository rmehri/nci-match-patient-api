class StateMachine
  include HTTParty
  base_uri 'localhost:10241'

  def self.validate(message)
    begin
      options = {
          body: message.to_json
      }
      result = post("/patientMessage", options)
      # p "result.to_s";
      # p result.to_s;
      result.to_s;
    rescue Error => error
      p error
    end
  end
end

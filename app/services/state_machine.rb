class StateMachine
  include HTTParty
  base_uri 'localhost:10241'

  def self.validate(message)
    begin
      options = {
          body: message
      }

      result = post("/patientMessage", options)

      # p "message = "+message.to_s
      # p "result = "+result.to_s
      return result;
    rescue Error => error
      p error
    end
  end
end

# message = '{"blah": "blah"}'

# puts StateMachine.validate message

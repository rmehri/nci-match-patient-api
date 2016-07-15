class StateMachine
  include HTTParty
  base_uri 'localhost:10241'

  def self.validate(message)
    begin
      # options = {
      #     body: message.to_json
      # }
      # result = post("/patientMessage", options)

      result = post("/patientMessage",
                    {
                        :body => message.to_json,
                        :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
                    })
      result.to_s;
    rescue Error => error
      p error
    end
  end
end

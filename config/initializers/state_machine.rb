module NciMatchPatientApi
  class StateMachine
    def self.validate(message)
      begin
        # Mock implementation
        return JSON.parse(message)["valid"].to_b;
      rescue Aws::SQS::Errors::ServiceError => error
        p error
      end
    end
  end
end

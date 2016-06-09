module NciMatchPatientApi
  class StateMachine
    def self.validate(message)
      begin
        # Mock implementation
        return message[:valid];
      rescue Aws::SQS::Errors::ServiceError => error
        p error
      end
    end
  end
end

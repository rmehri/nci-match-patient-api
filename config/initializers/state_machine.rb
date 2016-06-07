module NciMatchPatientApi
  class StateMachine
    def self.validate(message)
      begin
        true
      rescue Aws::SQS::Errors::ServiceError => error
        p error
      end
    end
  end
end

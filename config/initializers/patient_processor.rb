module NciMatchPatientApi
  class PatientProcessor
    def self.send(message)
      begin
        # Mock implementation
        return JSON.parse(message)["valid"].to_b;
      rescue Aws::SQS::Errors::ServiceError => error
        p error
      end
    end
  end
end

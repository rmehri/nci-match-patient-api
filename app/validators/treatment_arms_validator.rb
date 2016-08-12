module MessageValidator
  class TreatmentArmsValidator
    def self.schema
      @schema = {
          "type" => "object",
          "required" => ["treatment_arms"],
          "properties" => {
              "treatment_arms" => {"type" => "array"}

          }
      }
    end
  end
end

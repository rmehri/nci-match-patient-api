module MessageValidator
  class VariantValidator

    def self.schema
      @schema = {
          "type" => "object",
          "required" => ["patient_id", "surgical_event_id","molecular_id", "status","analysis_id"],
          "properties" => {
              "patient_id" => {"type" => "string", "minLength" => 1},
              "surgical_event_id" => {"type" => "string", "minLength" => 1},
              "molecular_id" => {"type" => "string", "minLength" => 1},
              "analysis_id" => {"type" => "string", "minLength" => 1},
              "status" => {"type" => "string", "minLength" => 1,
                           "enum" => ["PENDING",
                                      "CONFIRMED",
                                      "REJECTED"]
              }
          }
      }
    end
  end
end
module MessageValidator
  class PathologyValidator

    def self.schema
      @schema = {
          "type" => "object",
          "required" => ["patient_id", "surgical_event_id", "status", "reported_date"],
          "properties" => {
              "patient_id" => {"type" => "string", "minLength" => 1},
              "surgical_event_id" => {"type" => "string", "minLength" => 1},
              "status" => {"type" => "string", "minLength" => 1,
                           "enum" => ["Y",
                                      "N",
                                      "U"]
              }
          }
      }
    end
  end
end
module MessageValidator
  class AssayValidator

    def self.schema
      @schema = {
          "type" => "object",
          "required" => ["patient_id", "study_id", "surgical_event_id", "biomarker", "reported_date", "result"],
          "properties" => {
              "study_id" => {"type" => "string", "minLength" => 1,
                             "enum" => ["APEC1621"]},
              "patient_id" => {"type" => "string", "minLength" => 1},
              "surgical_event_id" => {"type" => "string", "minLength" => 1},
              "biomarker" => {"type" => "string", "minLength" => 1
                              # "enum" => ["PTen",
                              #            "MSH",
                              #            "Third"]
              }
          }
      }
    end
  end
end
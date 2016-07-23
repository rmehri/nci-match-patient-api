module MessageValidator
  class SpecimenReceivedValidator

    def self.schema
      @schema = {
          "type" => "object",
          "required" => ["specimen_received"],
          "properties" => {
              "specimen_received" => {
                  "type" => "object",
                  "required" => ["patient_id", "surgical_event_id", "study_id", "type"],
                  "properties" => {
                      "study_id" => {"type" => "string", "minLength" => 1,
                                     "enum" => ["APEC1621"]},
                      "patient_id" => {"type" => "string", "minLength" => 1},
                      "type" => {"type" => "string", "minLength" => 1, "enum" => ["BLOOD", "TISSUE"]},
                      "surgical_event_id" => {"type" => "string", "minLength" => 1}
                  }
              }
          }
      }
    end
  end
end
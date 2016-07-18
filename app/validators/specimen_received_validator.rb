module MessageValidator
  class SpecimenReceivedValidator

    def self.schema
      @schema = {
          "type" => "object",
          "required" => ["specimen_received"],
          "properties" => {
              "specimen_received" => {
                  "type" => "object",
                  "required" => ["patient_id", "study_id", "type"],
                  "properties" => {
                      "patient_id" => {"type" => "string", "minLength" => 1},
                      "type" => {"type" => "string", "minLength" => 1, "enum" => ["BLOOD", "TISSUE"]}
                  }
              }
          }
      }
    end
  end
end
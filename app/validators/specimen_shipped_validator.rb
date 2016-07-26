module MessageValidator
  class SpecimenShippedValidator

    def self.schema
      @schema = {
          "type" => "object",
          "required" => ["specimen_shipped"],
          "properties" => {
              "specimen_shipped" => {
                  "type" => "object",
                  "required" => ["patient_id", "study_id", "surgical_event_id", "molecular_id" ,"type", "carrier", "tracking_id"],
                  "properties" => {
                      "study_id" => {"type" => "string", "minLength" => 1,
                                     "enum" => ["APEC1621"]},
                      "patient_id" => {"type" => "string", "minLength" => 1},
                      "type" => {"type" => "string", "minLength" => 1, "enum" => ["BLOOD_DNA", "TISSUE_DNA_AND_CDNA", "SLIDE"]},
                      "surgical_event_id" => {"type" => "string", "minLength" => 1},
                      "molecular_id" => {"type" => "string", "minLength" => 1}
                  }
              }
          }
      }
    end

  end
end
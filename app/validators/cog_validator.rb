module MessageValidator
  class CogValidator

    def self.schema
      @schema = {
          "type" => "object",
          "required" => ["patient_id", "status", "study_id"],
          "properties" => {
              "patient_id" => {"type" => "string", "minLength" => 1},
              "study_id" => {"type" => "string", "minLength" => 1,
                             "enum" => ["APEC1621"]},
              "status" => {"type" => "string", "minLength" => 1,
                           "enum" => ["REGISTRATION",
                                      "PROGRESSION",
                                      "TOXICITY",
                                      "REGIMEN_COMPLETED",
                                      "OFF_STUDY",
                                      "OFF_STUDY_NOT_CONSENTED",
                                      "OFF_STUDY_DECEASED",
                                      "OFF_STUDY_BIOPSY_EXPIRED",
                                      "NO_TA_AVAILABLE",
                                      "PENDING_APPROVAL",
                                      "COMPASSIONATE_CARE",
                                      "ON_TREATMENT_ARM",
                                      "TREATMENT_ARM_SUSPENDED",
                                      "TREATMENT_ARM_CLOSED",
                                      "NOT_ELIGIBLE",
                                      "NOT_ENROLLING"]}
          }
      }
    end

    def self.registration_schema
      @schema = {
          "type" => "object",
          "required" => ["patient_id", "status", "study_id"],
          "properties" => {
              "patient_id" => {"type" => "string", "minLength" => 1},
              "study_id" => {"type" => "string", "minLength" => 1,
                             "enum" => ["APEC1621"]},
              "step_number" => {"type" => "number", "maximum" => 1},
              "status" => {"type" => "string", "minLength" => 1,
                           "enum" => ["REGISTRATION"]}
          }
      }
    end
   end
end
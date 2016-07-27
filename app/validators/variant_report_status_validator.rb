module MessageValidator
  class VariantReportStatusValidator
    def self.schema
      @schema = {
          "type" => "object",
          "required" => ["patient_id", "molecular_id", "analysis_id", "status", "comment", "comment_user"],
          "properties" => {
              "patient_id" => {"type" => "string", "minLength" => 1},
              "molecular_id" => {"type" => "string", "minLength" => 1},
              "analysis_id" => {"type" => "string", "minLength" => 1},
              "comment" => {"type" => "string", "minLength" => 1},
              "comment_user" => {"type" => "string", "minLength" => 1},
              "status" => {"type" => "string", "minLength" => 1, "enum" => ["CONFIRMED",
                                                                            "REJECTED"]}
          }
      }
    end

  end
end

module MessageValidator
  class VariantValidator

    def self.schema
      @schema = {
          "type" => "object",
          "required" => ["patient_id",
                         "molecular_id",
                         "analysis_id",
                         "s3_bucket_name",
                         "tsv_file_path_name",
                         "vcf_file_path_name",
                         "dna_bam_file_path_name",
                         "cdna_bam_file_path_name"
                         ],
          "properties" => {
              "patient_id" => {"type" => "string", "minLength" => 1},
              "surgical_event_id" => {"type" => "string", "minLength" => 1},
              "molecular_id" => {"type" => "string", "minLength" => 1},
              "analysis_id" => {"type" => "string", "minLength" => 1},
              "s3_bucket_name" => {"type" => "string", "minLength" => 1},
              "tsv_file_path_name" => {"type" => "string", "minLength" => 1},
              "vcf_file_path_name" => {"type" => "string", "minLength" => 1},
              "dna_bam_file_path_name" => {"type" => "string", "minLength" => 1},
              "cdna_bam_file_path_name" => {"type" => "string", "minLength" => 1}
          }
      }
    end
  end
end
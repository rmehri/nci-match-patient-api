module Convert

  class PatientDbModel
    def self.to_ui_model(patient_dbm, events_dbm, biopsies_dbm, variant_reports_dbm, variants_dbm, specimens_dbm)
      uiModel = PatientUiModel.new

      uiModel.patient_id           = patient_dbm.patient_id
      uiModel.registration_date    = patient_dbm.registration_date
      uiModel.study_id             = patient_dbm.study_id
      uiModel.gender               = patient_dbm.gender
      uiModel.ethnicity            = patient_dbm.ethnicity
      uiModel.races                = patient_dbm.races
      uiModel.current_step_number  = patient_dbm.current_step_number
      uiModel.current_assignment   = patient_dbm.current_assignment
      uiModel.current_status       = patient_dbm.current_status

      uiModel.disease              = patient_dbm.disease
      uiModel.prior_drugs          = patient_dbm.prior_drugs
      uiModel.documents            = patient_dbm.documents

      if events_dbm != nil
        uiModel.timeline = events_dbm.map { |e_dbm| e_dbm.data_to_h }
      end

      if biopsies_dbm != nil
        uiModel.biopsy_selectors = biopsies_dbm.map { |b_dbm| to_ui_biopsy_selector b_dbm }
        uiModel.biopsy = biopsies_dbm[biopsies_dbm.size - 1].data_to_h
      end

      if variant_reports_dbm != nil
        uiModel.variant_report_selectors = variant_reports_dbm.map { |vr_dbm| to_ui_variant_report_selector vr_dbm }
        uiModel.variant_report = to_ui_variant_report(variant_reports_dbm[variant_reports_dbm.size - 1], variants_dbm)
      end

      return uiModel
    end

    private

    def self.to_ui_biopsy_selector(dbm)
      {"text" => dbm.type, "biopsy_sequence_number" => dbm.biopsy_sequence_number}
    end

    def self.to_ui_variant_report_selector(dbm)
      {
          "text" => dbm.cg_id,
          "variant_report_received_date" => dbm.variant_report_received_date
      }
    end

    def self.to_ui_variant_report(report_dbm, variants_dbm)
      {
        "cg_id"                        => report_dbm.cg_id,
        "variant_report_received_date" => report_dbm.variant_report_received_date,
        "patient_id"                   => report_dbm.patient_id,
        "molecular_id"                 => report_dbm.molecular_id,
        "analysis_id"                  => report_dbm.analysis_id,
        "status"                       => report_dbm.status,
        "confirmed_date"               => report_dbm.confirmed_date,
        "rejected_date"                => report_dbm.rejected_date,
        "dna_bam_file_path"            => report_dbm.dna_bam_file_path,
        "dna_bai_file_path"            => report_dbm.dna_bai_file_path,
        "rna_bam_file_path"            => report_dbm.rna_bam_file_path,
        "rna_bai_file_path"            => report_dbm.rna_bai_file_path,
        "vcf_path"                     => report_dbm.vcf_path,
        "variants"                     => {
            "single_nucleitide_variants" => query_variants(variants_dbm, "single_nucleitide_variants"),
            "indels"                     => query_variants(variants_dbm, "indels"),
            "copyNumberVariants"         => query_variants(variants_dbm, "copyNumberVariants"),
            "geneFusions"                => query_variants(variants_dbm, "geneFusions")
        }
      }
    end

    def self.query_variants(variants_dbm, variant_type)
      if (variants_dbm != nil)
        variants_dbm
            .select {|v| v.variant_type == variant_type}
            .map { |v| v.data_to_h }
      else
        []
      end
    end

  end

end

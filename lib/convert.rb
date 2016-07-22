module Convert

  class PatientDbModel
    def self.to_ui_model(patient_dbm, events_dbm, variant_reports_dbm, variants_dbm, specimens_dbm)
      uiModel = PatientUiModel.new

      uiModel.patient_id           = patient_dbm.patient_id
      uiModel.registration_date    = patient_dbm.registration_date
      uiModel.study_id             = patient_dbm.study_id
      uiModel.gender               = patient_dbm.gender || 'Gender Unknown'
      uiModel.ethnicity            = patient_dbm.ethnicity || 'Ethnicity Unknown'
      uiModel.races                = patient_dbm.races || 'Race Unknown'
      uiModel.current_step_number  = patient_dbm.current_step_number
      uiModel.current_assignment   = patient_dbm.current_assignment
      uiModel.current_status       = patient_dbm.current_status

      uiModel.disease              = patient_dbm.disease
      uiModel.prior_drugs          = patient_dbm.prior_drugs
      uiModel.documents            = patient_dbm.documents
      uiModel.message              = patient_dbm.message

      if events_dbm != nil && events_dbm.length > 0
        uiModel.timeline = events_dbm.map { |e_dbm| e_dbm.data_to_h }
      end

      if variant_reports_dbm != nil && variant_reports_dbm.length > 0
        uiModel.variant_reports = variant_reports_dbm
        # uiModel.variant_reports = to_ui_variant_report(variant_reports_dbm, nil)
      end

      if patient_dbm.current_assignment != nil
        uiModel.assignment_report = patient_dbm.current_assignment
      end

      if specimens_dbm != nil && specimens_dbm.length > 0
        # uiModel.specimen_selectors = specimens_dbm.map { |s_dbm| to_ui_specimen_selector s_dbm }
        # uiModel.specimen = specimens_dbm[specimens_dbm.length - 1].data_to_h
        uiModel.specimens = specimens_dbm.map { |s_dbm| s_dbm.data_to_h }
      end

      return uiModel
    end

    private

    def self.to_ui_specimen_selector(dbm)
      {"text" => dbm.surgical_event_id, "collected_date" => dbm.collected_date}
    end

    def self.to_ui_variant_report_selector(dbm)
      {
          "text" => dbm.surgical_event_id,
          "variant_report_received_date" => dbm.variant_report_received_date
      }
    end

    def self.to_ui_variant_report(report_dbm)

      report = {
          "surgical_event_id"            => report_dbm.surgical_event_id,
          "variant_report_received_date" => report_dbm.variant_report_received_date,
          "patient_id"                   => report_dbm.patient_id,
          "molecular_id"                 => report_dbm.molecular_id,
          "analysis_id"                  => report_dbm.analysis_id,
          "status"                       => report_dbm.status,
          "status_date"                  => report_dbm.status_date,
          "dna_bam_file_path"            => report_dbm.dna_bam_path_name,
          "dna_bai_file_path"            => report_dbm.dna_bai_path_name,
          "rna_bam_file_path"            => report_dbm.rna_bam_path_name,
          "rna_bai_file_path"            => report_dbm.rna_bai_path_name,
          "vcf_path"                     => report_dbm.vcf_path_name,
          "s3_bucket"                    => report_dbm.s3_bucket
          # "total_variants"               => report_dbm.total_variants,
          # "cellularity"                  => report_dbm.cellularity,
          # "total_mois"                   => report_dbm.total_mois,
          # "total_amois"                  => report_dbm.total_amois,
          # "total_confirmed_mois"         => report_dbm.total_confirmed_mois,
          # "total_confirmed_amois"        => report_dbm.total_confirmed_amois,
          # "variants"                     => {
          #     "single_nucleitide_variants" => query_variants(variants_dbm, "single_nucleitide_variants"),
          #     "indels"                     => query_variants(variants_dbm, "indels"),
          #     "copyNumberVariants"         => query_variants(variants_dbm, "copyNumberVariants"),
          #     "geneFusions"                => query_variants(variants_dbm, "geneFusions")
          # }
      }
      report
    end

    def self.to_ui_variants(variants_dbm)
      variants = {
                "single_nucleitide_variants" => query_variants(variants_dbm, "single_nucleotide_variants"),
                "indels"                     => query_variants(variants_dbm, "indels"),
                "copyNumberVariants"         => query_variants(variants_dbm, "copy_number_variants"),
                "geneFusions"                => query_variants(variants_dbm, "unified_gene_fusions")
            }
      variants
    end

    # def self.to_ui_variant_report(reports_dbm, variants_dbm)
    #   reports = []
    #   reports_dbm.each do |report_dbm|
    #     reports << {
    #       "surgical_event_id"            => report_dbm.surgical_event_id,
    #       "variant_report_received_date" => report_dbm.variant_report_received_date,
    #       "patient_id"                   => report_dbm.patient_id,
    #       "molecular_id"                 => report_dbm.molecular_id,
    #       "analysis_id"                  => report_dbm.analysis_id,
    #       "status"                       => report_dbm.status,
    #       "status_date"                  => report_dbm.status_date,
    #       "dna_bam_file_path"            => report_dbm.dna_bam_path_name,
    #       "dna_bai_file_path"            => report_dbm.dna_bai_path_name,
    #       "rna_bam_file_path"            => report_dbm.rna_bam_path_name,
    #       "rna_bai_file_path"            => report_dbm.rna_bai_path_name,
    #       "vcf_path"                     => report_dbm.vcf_path_name,
    #       "s3_bucket"                    => report_dbm.s3_bucket,
    #       "total_variants"               => report_dbm.total_variants,
    #       "cellularity"                  => report_dbm.cellularity,
    #       "total_mois"                   => report_dbm.total_mois,
    #       "total_amois"                  => report_dbm.total_amois,
    #       "total_confirmed_mois"         => report_dbm.total_confirmed_mois,
    #       "total_confirmed_amois"        => report_dbm.total_confirmed_amois,
    #       "variants"                     => {
    #           "single_nucleitide_variants" => query_variants(variants_dbm, "single_nucleitide_variants"),
    #           "indels"                     => query_variants(variants_dbm, "indels"),
    #           "copyNumberVariants"         => query_variants(variants_dbm, "copyNumberVariants"),
    #           "geneFusions"                => query_variants(variants_dbm, "geneFusions")
    #       }
    #     }
    #   end
    #
    # end

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

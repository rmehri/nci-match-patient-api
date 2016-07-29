module Convert

  class PatientDbModel
    def self.to_ui_model(patient_dbm, variant_reports_dbm, variants_dbm, specimens_dbm, shipments_dbm)
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


      if variant_reports_dbm != nil && variant_reports_dbm.length > 0
        uiModel.variant_reports = to_ui_variant_reports(variant_reports_dbm, variants_dbm)
      end

      if patient_dbm.current_assignment != nil
        uiModel.assignment_report = patient_dbm.current_assignment
      end

      if specimens_dbm != nil && specimens_dbm.length > 0
        uiModel.specimens = to_ui_specimens(specimens_dbm, shipments_dbm)
      end

      return uiModel
    end

    private

    # def self.to_ui_specimen_selector(dbm)
    #   {"text" => dbm.surgical_event_id, "collected_date" => dbm.collected_date}
    # end
    #
    # def self.to_ui_variant_report_selector(dbm)
    #   {
    #       "text" => dbm.surgical_event_id,
    #       "variant_report_received_date" => dbm.variant_report_received_date
    #   }
    # end

    def self.to_ui_specimens(specimens_dbm, shipments_dbm)
      specimens_ui = []

      specimens_dbm.each do | specimen_dbm |
        specimen_ui = specimen_dbm.data_to_h

        specimen_shipments_dbm = []
        if (specimen_dbm.type == 'TISSUE')
          specimen_shipments_dbm = shipments_dbm
              .select {|v| (v.surgical_event_id == specimen_dbm.surgical_event_id)}
        else
          specimen_shipments_dbm = shipments_dbm
                                       .select {|v| (v.type == 'BLOOD_DNA')}
        end

        specimen_ui['specimen_shipments'] = specimen_shipments_dbm.map { |shipment_dbm| shipment_dbm.data_to_h }
        specimens_ui.push(specimen_ui)
      end

      specimens_ui
    end

    def self.to_ui_variant_reports(variant_reports_dbm, variants_dbm)
      variant_reports_ui = []

      variant_reports_dbm.each do |variant_report_dbm|
        variant_report_ui = to_ui_variant_report(variant_report_dbm)

        variants_dbm_for_report = select_variants_for_variant_report(variants_dbm,
                                                                     variant_report_dbm.molecular_id,
                                                                     variant_report_dbm.analysis_id)

        variants_ui = to_ui_variants_by_variant_type(variants_dbm_for_report)
        variant_report_ui['variants'] = variants_ui

        total_mois = 0
        total_amois = 0
        total_confirmed_mois = 0
        total_confirmed_amoi = 0

        variants_dbm_for_report.each do | variant_dbm |
          total_mois += 1
          total_amois += 1 if variant_dbm.is_amois
          total_confirmed_mois += 1 if (variant_dbm.confirmed)
          total_confirmed_amois +=1 if (variant_dbm.confirmed && variant_dbm.is_amois)
        end

        variant_report_ui['total_mois']  = total_mois
        variant_report_ui['total_amois']  = total_amois
        variant_report_ui['total_confirmed_mois']  = total_confirmed_mois
        variant_report_ui['total_confirmed_amois']  = total_confirmed_amoi

        variant_reports_ui.push(variant_report_ui)
      end

      variant_reports_ui
    end

    def self.select_variants_for_variant_report(variants_dbm, molecular_id, analysis_id)
      variants_dbm_for_report = []
      if (variants_dbm != nil)
        variants_dbm_for_report = variants_dbm
            .select {|v| (v.molecular_id == molecular_id && v.analysis_id == analysis_id)}
      end

      AppLogger.log_debug(self.class.name, "Variant report [#{molecular_id} | #{analysis_id}] has #{variants_dbm_for_report.length} variants")
      variants_dbm_for_report
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
      }
      report
    end

    def self.to_ui_variants_by_variant_type(variants_dbm)
      variants_ui_snv = query_variants(variants_dbm, "single_nucleotide_variants")
      variants_ui_indels = query_variants(variants_dbm, "indels")

      variants = {
          "snvs_and_indels"            => variants_ui_snv.push(*variants_ui_indels),
          "copy_number_variants"         => query_variants(variants_dbm, "copy_number_variants"),
          "gene_fusions"                => query_variants(variants_dbm, "unified_gene_fusions")
      }
      variants
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

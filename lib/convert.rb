# module Convert
#
#   class PatientDbModel
#     def self.to_ui_model(patient_dbm, variant_reports_dbm, variants_dbm, specimens_dbm, shipments_dbm)
#       uiModel = PatientUiModel.new
#
#       uiModel.patient_id           = patient_dbm.patient_id
#       uiModel.registration_date    = patient_dbm.registration_date
#       uiModel.study_id             = patient_dbm.study_id
#       uiModel.gender               = patient_dbm.gender || 'Gender Unknown'
#       uiModel.ethnicity            = patient_dbm.ethnicity || 'Ethnicity Unknown'
#       uiModel.races                = patient_dbm.races || 'Race Unknown'
#       uiModel.current_step_number  = patient_dbm.current_step_number
#       uiModel.current_assignment   = patient_dbm.current_assignment
#       uiModel.current_status       = patient_dbm.current_status
#
#       uiModel.disease              = patient_dbm.diseases
#       uiModel.prior_drugs          = patient_dbm.prior_drugs
#       uiModel.documents            = patient_dbm.documents
#       uiModel.message              = patient_dbm.message
#
#       if variant_reports_dbm != nil && variant_reports_dbm.length > 0
#         uiModel.variant_reports = to_ui_variant_reports(variant_reports_dbm, variants_dbm)
#       end
#
#       unless patient_dbm.current_assignment.nil?
#         uiModel.assignment_report = patient_dbm.current_assignment
#       end
#
#       if specimens_dbm != nil && specimens_dbm.length > 0
#         uiModel.specimens = to_ui_specimens(specimens_dbm, shipments_dbm, variant_reports_dbm)
#       end
#
#       return uiModel
#     end
#
#     private
#
#     def self.to_ui_specimens(specimens_dbm, shipments_dbm, variant_reports_dbm)
#       specimens_ui = []
#
#       specimens_dbm.each do | specimen_dbm |
#         specimen_ui = specimen_dbm.to_h
#
#         specimen_shipments_dbm = []
#         if (specimen_dbm.type == 'TISSUE')
#           specimen_shipments_dbm = shipments_dbm
#               .select {|v| (v.surgical_event_id == specimen_dbm.surgical_event_id)}
#         else
#           specimen_shipments_dbm = shipments_dbm
#                                        .select {|v| (v.type == 'BLOOD_DNA')}
#         end
#
#         shipments_uims = []
#
#         specimen_shipments_dbm.each do | shipment_dbm |
#           shipment_uim = shipment_dbm.to_h
#
#           shipment_uim['analyses'] = variant_reports_dbm
#               .select {|vr| vr.surgical_event_id == shipment_dbm.surgical_event_id && vr.molecular_id == shipment_dbm.molecular_id }
#               .map { |vr|
#                 {
#                   "analysis_id" => vr.analysis_id,
#                   "variant_report_received_date" => vr.variant_report_received_date,
#                   "status" => vr.status,
#                   "status_date" => vr.status_date,
#                   "comment" => vr.comment,
#                   "comment_user" => vr.comment_user,
#                   "dna_bam_name" => get_s3_url(vr.ion_reporter_id, vr.molecular_id, vr.analysis_id, vr.dna_bam_name),
#                   "dna_bai_name" => get_s3_url(vr.ion_reporter_id, vr.molecular_id, vr.analysis_id, vr.dna_bai_name),
#                   "cdna_bam_name" => get_s3_url(vr.ion_reporter_id, vr.molecular_id, vr.analysis_id, vr.cdna_bam_name),
#                   "cdna_bai_name" => get_s3_url(vr.ion_reporter_id, vr.molecular_id, vr.analysis_id, vr.cdna_bai_name),
#                   "vcf_path_name"     => get_s3_url(vr.ion_reporter_id, vr.molecular_id, vr.analysis_id, vr.vcf_file_name),
#                   "tsv_path_name"     => get_s3_url(vr.ion_reporter_id, vr.molecular_id, vr.analysis_id, vr.tsv_file_name),
#                   "qc_report_url"     => get_qc_report_url(vr.ion_reporter_id, vr.molecular_id, vr.analysis_id, vr.tsv_file_name),
#                   "vr_chart_data_url" => get_vr_chart_url(vr.ion_reporter_id, vr.molecular_id, vr.analysis_id, vr.vcf_file_name)
#                 }
#               }
#
#           shipments_uims.push(shipment_uim)
#         end
#
#         specimen_ui['specimen_shipments'] = shipments_uims
#         specimens_ui.push(specimen_ui)
#       end
#
#       specimens_ui
#     end
#
#     def self.get_qc_report_url(ion_reporter_id, molecular_id, analysis_id, file_name)
#       if (ion_reporter_id.blank? || molecular_id.blank? || analysis_id.blank? || file_name.blank?)
#         return nil
#       end
#
#       qc_file = File.basename(file_name, ".tsv") + ".qc_report.json"
#
#       p 'qc_file =' + qc_file.to_s
#
#       return "#{Rails.configuration.environment.fetch('s3_url')}/#{Rails.configuration.environment.fetch('s3_bucket')}/#{ion_reporter_id}/#{molecular_id}/#{analysis_id}/#{qc_file}"
#     end
#
#     def self.get_s3_url(ion_reporter_id, molecular_id, analysis_id, file_name)
#       if (ion_reporter_id.blank? || molecular_id.blank? || analysis_id.blank? || file_name.blank?)
#         return nil
#       end
#
#       return "#{Rails.configuration.environment.fetch('s3_url')}/#{Rails.configuration.environment.fetch('s3_bucket')}/#{ion_reporter_id}/#{molecular_id}/#{analysis_id}/#{file_name}"
#     end
#
#     def self.get_vr_chart_url(ion_reporter_id, molecular_id,analysis_id, file_name)
#
#       if (ion_reporter_id.blank? || molecular_id.blank? || analysis_id.blank? || file_name.blank?)
#         return nil
#       end
#
#       chart_file = File.basename(file_name, ".vcf") + ".vr_chart.json"
#       p 'chart_file =' + chart_file.to_s
#
#       return "#{Rails.configuration.environment.fetch('s3_url')}/#{Rails.configuration.environment.fetch('s3_bucket')}/#{ion_reporter_id}/#{molecular_id}/#{analysis_id}/#{chart_file}"
#     end
#
#     def self.to_ui_variant_reports(variant_reports_dbm, variants_dbm)
#       variant_reports_ui = []
#
#       variant_reports_dbm.each do |variant_report_dbm|
#         variant_report_ui = to_ui_variant_report(variant_report_dbm)
#
#         variants_dbm_for_report = select_variants_for_variant_report(variants_dbm,
#                                                                      variant_report_dbm.molecular_id,
#                                                                      variant_report_dbm.analysis_id)
#
#         variants_ui = to_ui_variants_by_variant_type(variants_dbm_for_report)
#         variant_report_ui['variants'] = variants_ui
#
#         variant_reports_ui.push(variant_report_ui)
#       end
#
#       variant_reports_ui
#     end
#
#     def self.select_variants_for_variant_report(variants_dbm, molecular_id, analysis_id)
#       variants_dbm_for_report = []
#       unless variants_dbm.nil?
#         variants_dbm_for_report = variants_dbm
#             .select {|v| (v.molecular_id == molecular_id && v.analysis_id == analysis_id)}
#       end
#
#       AppLogger.log_debug(self.class.name, "Variant report [#{molecular_id} | #{analysis_id}] has #{variants_dbm_for_report.length} variants")
#       variants_dbm_for_report
#     end
#
#     def self.to_ui_variant_report(report_dbm)
#       ion_reporter_id = report_dbm.ion_reporter_id
#       molecular_id = report_dbm.molecular_id
#       analysis_id = report_dbm.analysis_id
#
#
#       report = {
#           "surgical_event_id"            => report_dbm.surgical_event_id,
#           "variant_report_received_date" => report_dbm.variant_report_received_date,
#           "variant_report_type"          => report_dbm.variant_report_type,
#           "patient_id"                   => report_dbm.patient_id,
#           "molecular_id"                 => molecular_id,
#           "analysis_id"                  => analysis_id,
#           "ion_reporter_id"                     => ion_reporter_id,
#           "status"                       => report_dbm.status,
#           "status_date"                  => report_dbm.status_date,
#           "dna_bam_name"                => get_s3_url(ion_reporter_id, molecular_id,analysis_id, report_dbm.dna_bam_name),
#           "dna_bai_name"                => get_s3_url(ion_reporter_id, molecular_id,analysis_id, report_dbm.dna_bai_name),
#           "cdna_bam_name"               => get_s3_url(ion_reporter_id, molecular_id,analysis_id, report_dbm.cdna_bam_name),
#           "cdna_bai_name"               => get_s3_url(ion_reporter_id, molecular_id,analysis_id, report_dbm.cdna_bai_name),
#           "tsv_file_name"                => get_s3_url(ion_reporter_id, molecular_id,analysis_id, report_dbm.tsv_file_name),
#           "vcf_file_name"                => get_s3_url(ion_reporter_id, molecular_id,analysis_id, report_dbm.vcf_file_name),
#           "total_variants"               => report_dbm.total_variants,
#           "cellularity"                  => report_dbm.cellularity,
#           "mapd"                         => report_dbm.mapd,
#           "total_mois"                   => report_dbm.total_mois,
#           "total_amois"                  => report_dbm.total_amois,
#           "total_confirmed_mois"         => report_dbm.total_confirmed_mois,
#           "total_confirmed_amois"        => report_dbm.total_confirmed_amois,
#           "qc_report_url" => get_qc_report_url(ion_reporter_id, molecular_id,analysis_id, report_dbm.tsv_file_name),
#           "vr_chart_data_url" => get_vr_chart_url(ion_reporter_id, molecular_id, analysis_id, report_dbm.vcf_file_name)
#       }
#       report
#     end
#
#     def self.to_ui_variants_by_variant_type(variants_dbm)
#       variants_ui_snv = query_variants(variants_dbm, "single_nucleotide_variants")
#       variants_ui_indels = query_variants(variants_dbm, "indels")
#
#       variants = {
#           "snvs_and_indels"            => variants_ui_snv.push(*variants_ui_indels),
#           "copy_number_variants"       => query_variants(variants_dbm, "copy_number_variants"),
#           "gene_fusions"               => query_variants(variants_dbm, "gene_fusions")
#       }
#       variants
#     end
#
#     def self.to_ui_variants(variants_dbm)
#       variants = {
#                 "single_nucleitide_variants" => query_variants(variants_dbm, "single_nucleotide_variants"),
#                 "indels"                     => query_variants(variants_dbm, "indels"),
#                 "copyNumberVariants"         => query_variants(variants_dbm, "copy_number_variants"),
#                 "geneFusions"                => query_variants(variants_dbm, "gene_fusions")
#             }
#       variants
#     end
#
#     def self.query_variants(variants_dbm, variant_type)
#       if variants_dbm != nil
#         variants_dbm
#             .select {|v| v.variant_type == variant_type}
#             .map { |v|
#
#           v_hash = v.to_h
#           v_hash.delete_if { |_key, value| value.blank? }
#           v_hash
#           # v.to_h
#         }
#       else
#         []
#       end
#     end
#   end
# end

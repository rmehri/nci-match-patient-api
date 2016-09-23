module V2
  class VariantReportsController < BaseController

    private
    def patient_params
      params.require(:patient_id).permit(:variant_report_received_date)
    end

    def query_params
      parameters = params.permit(:projections, :patient_id, :variant_report_received_date,
                                 :molecular_id, :analysis_id, :status, :status_date, :comment,
                                 :comment_user, :dna_bam_name, :dna_bai_name, :rna_bam_name, :rna_bai_name,
                                 :vcf_file_name, :tsv_file_name, :total_variants, :cellularity, :total_mois,
                                 :total_amois, :total_confirmed_mois, :total_confirmed_amois,
                                 :specimen_received_date, :clia_lab)
      build_query(parameters)
    end

  end
end
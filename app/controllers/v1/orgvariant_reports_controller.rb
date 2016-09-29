module V1
  class OrgVariantReportsController < BaseController

    private
    def variant_reports_params
      build_query({:analysis_id => params.require(:id)})
    end

    def query_params
      parameters = params.permit(:patient_id, :variant_report_received_date,
                                 :molecular_id, :analysis_id, :status, :status_date, :comment,
                                 :comment_user, :dna_bam_name, :dna_bai_name, :rna_bam_name, :rna_bai_name,
                                 :vcf_file_name, :tsv_file_name, :total_variants, :cellularity, :total_mois,
                                 :total_amois, :total_confirmed_mois, :total_confirmed_amois,
                                 :specimen_received_date, :clia_lab,
                                 :attributes, :projections, :projection => [], :attribute => [])
      build_query(parameters)
    end

  end
end
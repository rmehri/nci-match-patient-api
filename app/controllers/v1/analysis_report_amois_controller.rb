module V1
  class AnalysisReportAmoisController < BaseController
    before_action :authenticate_user
    skip_before_action :set_resource

    # GET /api/v1/patients/:patient_id/analysis_report_amois/:id
    def show

      # find variant_report
      variant_report = NciMatchPatientModels::VariantReport.query_by_analysis_id(params[:patient_id], params[:id])
      raise Errors::ResourceNotFound unless variant_report

      # process mois from rule, update variant_report and cache the transformed mois
      cached_amois_stats = MemoryCache.memoize(variant_report.to_h) do

        # get mois from rule engine
        mois_from_rule = VariantReportUpdater.updated_variant_report(variant_report.to_h.deep_symbolize_keys!, request.uuid, token)

        # update_mois will set amois counts and uuids; it will also update its count in variant_report
        report = AmoisAnalysisReport.new(variant_report, mois_from_rule)
        report.update_mois!

        # last expresion is cached - it is transformed result for print: {:total_amois => n, :snv_indels => [...], :copy_number_variants => [...], :gene_fusions => [...]}
        Convert::AmoisRuleModel.to_ui(report.updated_mois)
      end

      # render output
      render json: cached_amois_stats
    end

  end
end

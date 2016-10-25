module V1
  class VariantReportsController < BaseController

    def show
      begin
        variant_report = get_resource.first.to_h
        return standard_error_message("No record found", 404) if variant_report.blank?

        variants = get_variants(variant_report[:analysis_id])

        amois = get_amois(variant_report)
        variant_report = Convert::VariantReportDbModel.to_ui_model(variant_report, variants, amois)

        render json: variant_report
      rescue => error
        standard_error_message(error.message)
      end
    end

    private

    def get_variants(analysis_id)
      NciMatchPatientModels::Variant.scan(build_query({:analysis_id => analysis_id})).collect { |data| data.to_h.compact }
    end

    def get_amois(variant_report)
      VariantReportUpdater.new.updated_variant_report(variant_report)
    end

    def variant_reports_params
      build_query({:analysis_id => params.require(:id)})
    end

  end
end

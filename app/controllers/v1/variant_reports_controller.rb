module V1
  class VariantReportsController < BaseController
    before_action :set_resource, only: [:show]

    def show
      # begin
        variant_report = get_resource.first.to_h
        raise StandardError if variant_report.blank?

        variants = get_variants(variant_report[:analysis_id])

        amois = get_amois(variant_report)
        variant_report = Convert::VariantReportDbModel.to_ui_model(variant_report, variants, amois)

        render json: variant_report
      # rescue => error
      #   standard_error_message(error.message)
      # end
    end

    private
    def set_resource(resource = {})
      resources = NciMatchPatientModels::VariantReport.scan(resource_params).collect { |data| data.to_h.compact }
      instance_variable_set("@#{resource_name}", resources)
    end

    def get_variants(analysis_id)
      NciMatchPatientModels::Variant.scan(build_index_query({:analysis_id => analysis_id})).collect { |data| data.to_h.compact }
    end

    def get_amois(variant_report)
      VariantReportUpdater.new.updated_variant_report(variant_report)
    end

    def variant_reports_params
      params.require(:id)
      params[:analysis_id] = params.delete(:id)
      build_index_query(params.except(:action, :controller))
    end

  end
end

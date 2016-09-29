module V1
  class VariantReportEventsController < BaseController

    def index
      begin

        plural_resource_name = "@#{resource_name.pluralize}"

        variant_report = get_variant_report
        variants = get_variants
        amois = get_amois(variant_report)

        variant_report = Convert::VariantReportDbModel.to_ui_model(variant_report, variants, amois)

        instance_variable_set(plural_resource_name, variant_report)
        instance_variable_get(plural_resource_name)

        render json: instance_variable_get(plural_resource_name)
      rescue => error
        standard_error_message(error.message)
      end
    end

    private

    def get_variant_report
      variant_reports = NciMatchPatientModels::VariantReport.scan(query_params).collect { |data| data.to_h.compact }
      raise "Patient doesn't have a variant report with analysis id [#{params[:analysis_id]}]" if variant_reports.length == 0

      variant_reports[0]
    end

    def get_variants
      NciMatchPatientModels::Variant.scan(query_params).collect { |data| data.to_h.compact }
    end

    def get_amois(variant_report)
      VariantReportUpdater.new.updated_variant_report(variant_report)
    end

    def resource_class
      @resource_class ||= "NciMatchPatientModels::VariantReport".constantize
    end

    def variant_report_events_params
      params.require(:patient_id).permit(:patient_id, :analysis_id)
    end

    def query_params
      parameters = params.permit(:analysis_id)
      build_query(parameters)
    end

  end
end

module V1
  class ActionItemsController < BaseController
    before_action :set_resource, only: [:index]

    def index
      render json: instance_variable_get("@#{resource_name}")
    end

    private

    def set_resource(resources = {})

      patient = NciMatchPatientModels::Patient.query_patient_by_id(params[:patient_id])
      if (patient.current_status != "OFF_STUDY" && patient.current_status != "OFF_STUDY_BIOPSY_EXPIRED")
        resources = NciMatchPatientModels::VariantReport.scan(resource_params).collect { |record| build_model(record.to_h.compact) }
        resources += NciMatchPatientModels::Assignment.scan(assignment_resource_params).collect { |record| build_model(record.to_h.compact, 'assignment_report') }
      end

      instance_variable_set("@#{resource_name}", resources)
    end

    def assignment_resource_params
      resource_params.tap { |d| d[:scan_filter].tap { |h| h.delete(:variant_report_type) } }
    end

    def action_items_params
      build_index_query(patient_id: params.require(:patient_id), status: 'PENDING', variant_report_type: 'TISSUE')
    end

    def build_model(record, type = 'variant_report')
      {
        action_type: "pending_#{(type == 'variant_report') ? "#{record[:variant_report_type]}_#{type}" : type}".downcase,
        molecular_id: record[:molecular_id],
        analysis_id: record[:analysis_id],
        created_date: record[:status_date],
        assignment_uuid: record[:uuid]
      }
    end
  end
end


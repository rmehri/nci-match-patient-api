module V1

  class AnalysisReportController < BaseController

    def show
      render json: instance_variable_get("@#{resource_name}")
    end

    private
    def is_variant_report_reviewer(clia_lab)
      return false if clia_lab.nil?

      begin
        authorize! :variant_report_status, clia_lab.to_sym
        return true
      rescue => error
        p "=========== VR review role error: error"
        return false
      end

    end

    def is_assignment_reviewer
      begin
        authorize! :validate_json_message, "AssignmentStatus".to_sym
        return true
      rescue
        return false
      end

    end

    def set_resource(_resource = {})

      patient = NciMatchPatientModels::Patient.query_patient_by_id(params[:patient_id])
      return standard_error_message("Patient [#{params[:patient_id]}] not found", 404) if patient.blank?

      variant_report_hash = NciMatchPatientModelExtensions::VariantReportExtension.compose_variant_report(params[:patient_id], params[:id])
      raise Errors::ResourceNotFound if variant_report_hash.blank?

      variant_report_hash[:editable] = is_variant_report_reviewer(variant_report_hash[:clia_lab]) && variant_report_hash[:status] != "CONFIRMED"

      VariantReportHelper.add_download_links(variant_report_hash)

      assignments = NciMatchPatientModels::Assignment.query_by_patient_id(params[:patient_id], false).collect { |data| data.to_h.compact }
      assignments = assignments.sort_by{| assignment | assignment[:assignment_date]}.reverse

      assignments_with_assays = []
      assignments.each do | assignment |
        assignment[:editable] = is_assignment_reviewer && assignment[:status] != "CONFIRMED"
        assays = find_assays(assignment[:surgical_event_id])
        assignments_with_assays.push(Convert::AssignmentDbModel.to_ui(assignment, assays)) unless assignment.blank?
      end

      analysis_report = Convert::AnalysisReportDbModel.to_ui_model(patient.to_h.compact, variant_report_hash, assignments_with_assays)
      instance_variable_set("@#{resource_name}", analysis_report)
    end

    def find_assays(surgical_event_id)
      assays = []
      specimens = NciMatchPatientModels::Specimen.find_by({:surgical_event_id => surgical_event_id}).collect { |data| data.to_h.compact }
      assays = specimens[0][:assays] if specimens.length > 0
      assays
    end

    def get_variants(analysis_id)
      NciMatchPatientModels::Variant.scan(build_query({:analysis_id => analysis_id})).collect { |data| data.to_h.compact }
    end
  end
end

module V1
  class AnalysisReportController < BaseController
    skip_before_action :set_resource

    # GET /api/v1/patients/:id/analysis_report/:id
    def show
      # find patient
      patient = NciMatchPatientModels::Patient.query_patient_by_id(params[:patient_id])
      return standard_error_message("Patient [#{params[:patient_id]}] not found", 404) if patient.blank?

      # find variant_report
      variant_report_hash = NciMatchPatientModelExtensions::VariantReportExtension.compose_variant_report(params[:patient_id], params[:id])
      raise Errors::ResourceNotFound if variant_report_hash.blank?

      # mark variant_report as editable
      variant_report_hash[:editable] = variant_report_hash[:status] != "CONFIRMED" && authorize(:variant_report_status, variant_report_hash[:clia_lab]) # is_variant_report_reviewer?

      # add s3 links for files
      VariantReportHelper.add_download_links(variant_report_hash)

      # add assignments
      assignments = NciMatchPatientModels::Assignment.query_by_patient_id(params[:patient_id], false).collect { |data| data.to_h.compact }
      assignments = assignments.select {|assignment| assignment[:analysis_id] == params[:id]}
      assignments = assignments.sort_by{|assignment| assignment[:assignment_date]}.reverse

      assignments_with_assays = []
      assignments.each do | assignment |
        # mark assignment as editable
        assignment[:editable] = assignment[:status] != "CONFIRMED" && authorize(:validate_json_message, AssignmentStatusMessage) # is_assignment_reviewer ?
        assays = find_assays(assignment[:surgical_event_id])
        assignments_with_assays.push(Convert::AssignmentDbModel.to_ui(assignment, assays)) unless assignment.blank?
      end

      # render output - patient, variant_report and assignments
      render json: Convert::AnalysisReportDbModel.to_ui_model(patient.to_h.compact, variant_report_hash, assignments_with_assays)
    end

    private

    # find assay for surgical_event
    def find_assays(surgical_event_id)
      specimens = NciMatchPatientModels::Specimen.find_by({:surgical_event_id => surgical_event_id}).collect { |data| data.to_h.compact }
      specimens.length > 0 ? specimens[0][:assays] : []
    end
  end
end

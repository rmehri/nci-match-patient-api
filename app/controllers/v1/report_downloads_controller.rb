module V1
  # Handles the Patient Variant Report & Assignment Report downloads in .XLS format
  class ReportDownloadsController < BaseController
    def variant_report_download
      begin
        @variant_report = get_variant_report
        render xlsx: 'variant_report_download.xlsx.axlsx'
      rescue => error
        standard_error_message(error.message, 404)
      end
    end

    def assignment_report_download
      @assignment_report = get_assignment_report[0]
      render xlsx: 'assignment_report_download.xlsx.axlsx'
    end

    private

    def get_variant_report(_resource = {})
      patient = NciMatchPatientModels::Patient.query_patient_by_id(params[:patient_id])
      raise "Patient [#{params[:patient_id]}] not found" if patient.blank?

      variant_report_hash = NciMatchPatientModelExtensions::VariantReportExtension.compose_variant_report(params[:patient_id], params[:analysis_id])
      raise Errors::ResourceNotFound if variant_report_hash.blank?

      variant_report_hash[:editable] = is_variant_report_reviewer(variant_report_hash[:clia_lab]) && variant_report_hash[:status] != 'CONFIRMED'

      VariantReportHelper.add_download_links(variant_report_hash)
      assignments = NciMatchPatientModels::Assignment.query_by_patient_id(params[:patient_id], false).collect { |data| data.to_h.compact }
      assignments = assignments.sort_by { |assignment| assignment[:assignment_date] }.reverse

      assignments_with_assays = []
      assignments.each do |assignment|
        assignment[:editable] = is_assignment_reviewer && assignment[:status] != 'CONFIRMED'
        assays = find_assays(assignment[:surgical_event_id])
        assignments_with_assays.push(Convert::AssignmentDbModel.to_ui(assignment, assays)) unless assignment.blank?
      end

      analysis_report = Convert::AnalysisReportDbModel.to_ui_model(patient.to_h.compact, variant_report_hash, assignments_with_assays)
      instance_variable_set("@#{resource_name}", analysis_report)
    end

    def get_assignment_report(_resource = {})
      patient = NciMatchPatientModels::Patient.query_patient_by_id(params[:patient_id])
      raise "Patient [#{params[:patient_id]}] not found" if patient.blank?
      assignments = NciMatchPatientModels::Assignment.query_by_patient_id(params[:patient_id], false).collect { |data| data.to_h.compact }
      assignments = assignments.select { |assignment| assignment[:uuid] == params[:uuid]}
      assignment = assignments[0]
      assignments_with_assays = []
      assays = find_assays(assignment[:surgical_event_id])
      assignments_with_assays.push(Convert::AssignmentDbModel.to_ui(assignment, assays)) unless assignment.blank?
    end

    def find_assays(surgical_event_id)
      assays = []
      specimens = NciMatchPatientModels::Specimen.find_by(surgical_event_id: surgical_event_id).collect { |data| data.to_h.compact }
      assays = specimens[0][:assays] unless specimens.empty?
      assays
    end
  end
end

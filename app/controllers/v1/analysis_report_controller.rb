module V1
  class AnalysisReportController < ApplicationController
    def analysis_view
      begin
        patient = NciMatchPatientModels::Patient.query_patient_by_id(params[:patient_id])
        rails "Patient not found" if patient.blank?

        variant_report_hash = NciMatchPatientModelExtensions::VariantReportExtension.compose_variant_report({:patient_id => params[:patient_id],
                                                                                                             :analysis_id => params[:analysis_id]})

        assignments = NciMatchPatientModels::Assignment.query_by_patient_id(params[:patient_id], false).collect { |data| data.to_h.compact }
        assignments = assignments.sort_by{| assignment | assignment[:assignment_date]}.reverse

        assignments_with_assays = []
        assignments.each do | assignment |
          assays = find_assays(assignment[:surgical_event_id]) unless assignment[:surgical_event_id].blank?
          assignments_with_assays.push(Convert::AssignmentDbModel.to_ui(assignment, assays)) unless assignment.blank?
        end

        analysis_report = Convert::AnalysisReportDbModel.to_ui_model(patient.to_h.compact, variant_report_hash, assignments_with_assays)

        render json: analysis_report.to_json

      rescue => exception
        standard_error_message(exception.message)
      end
    end

    private
    def find_assays(surgical_event_id)
      assays = []
      specimens = NciMatchPatientModels::Specimen.find_by({:surgical_event_id => surgical_event_id}).collect { |data| data.to_h.compact }
      assays = specimens[0][:assays] if specimens.length > 0
      assays
    end
  end
end

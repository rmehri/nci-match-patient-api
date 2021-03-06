module Convert
  class AnalysisReportDbModel
    def self.to_ui_model(patient, variant_report_hash, assignments)
      { patient: to_patient_ui_model(patient), variant_report: variant_report_hash, assignments: assignments }
    end

    def self.to_patient_ui_model(patient)
      patient.deep_symbolize_keys!

      unless patient[:current_assignment].blank?
        unless patient[:current_assignment][:selected_treatment_arm].blank?
          selected_ta = patient[:current_assignment][:selected_treatment_arm]
          selected_ta[:treatment_arm_title] = ApplicationHelper.format_treatment_arm_title(selected_ta)

          patient[:current_assignment] = selected_ta
          # ApplicationHelper.merge_treatment_arm_fields(patient, patient[:current_assignment][:selected_treatment_arm])
        end

        # patient.delete(:current_assignment)
      end

      patient.delete(:active_tissue_specimen) unless patient[:active_tissue_specimen].nil?

      patient
    end
  end
end

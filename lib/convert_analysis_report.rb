module Convert
  class AnalysisReportDbModel
    def self.to_ui_model(patient, variant_report_hash, assignments)

      ui = {:patient => to_patient_ui_model(patient), :variant_report => variant_report_hash, :assignments => assignments}
      ui
    end

    def self.to_patient_ui_model(patient)
      patient.deep_symbolize_keys!
      puts "patient: #{patient.to_json}"

      if (!patient[:current_assignment].blank?)
        if (!patient[:current_assignment][:selected_treatment_arm].blank?)
          ApplicationHelper.merge_treatment_arm_fields(patient, patient[:current_assignment][:selected_treatment_arm])
        end

        patient.delete(:current_assignment)
      end

      patient.delete(:active_tissue_specimen) if !patient[:active_tissue_specimen].nil?

      patient
    end
  end
end

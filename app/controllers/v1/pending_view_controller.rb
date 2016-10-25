module V1
  class PendingViewController < ApplicationController
    def pending_view
      begin

        p "============== Getting pending view"
        variant_reports = NciMatchPatientModels::VariantReport.find_by({:status => 'PENDING'})

        tissue_reports = []
        blood_reports = []
        assignments = []
        variant_reports.each do | variant_report |
          data = {:patient_id => variant_report.patient_id,
                  :molecular_id => variant_report.molecular_id,
                  :analysis_id => variant_report.analysis_id,
                  :ion_reporter_id => variant_report.ion_reporter_id,
                  :variant_report_received_date => variant_report.variant_report_received_date}
          data[:diseases] = get_patient_diseases(variant_report.patient_id)
          data[:specimen_received_date] = get_specimen_received_date(variant_report.patient_id,
                                                                     variant_report.variant_report_type)
          tissue_reports.push(data) if variant_report.variant_report_type == 'TISSUE'
          blood_reports.push(data) if variant_report.variant_report_type == 'BLOOD'
        end


        assignment_reports = NciMatchPatientModels::Assignment.find_by({:status => 'PENDING'})
        assignment_reports.each do | assignment_report|
          data = {:patient_id => assignment_report.patient_id,
                  :molecular_id => assignment_report.molecular_id,
                  :analysis_id => assignment_report.analysis_id,
                  :assignment_date => assignment_report.assignment_date}
          data[:diseases] = get_patient_diseases(assignment_report.patient_id)
          data[:treatment_arm_title] = format_treatment_arm_title(assignment_report.selected_treatment_arm)
          assignments.push(data)
        end

        pending_view = {:tissue_variant_reports => tissue_reports,
                        :blood_variant_reports => blood_reports,
                        :assignment_reports => assignments}

        render json: pending_view.to_json

      rescue => error
        standard_error_message(error)
      end
    end

    def format_treatment_arm_title(selected_treatment_arm)
      return "" if selected_treatment_arm.blank?

      selected_treatment_arm.deep_symbolize_keys!
      "#{selected_treatment_arm[:treatment_arm_id]} (#{selected_treatment_arm[:stratum_id]}, #{selected_treatment_arm[:version]})"
    end

    def get_specimen_received_date(patient_id, type)
      if type == 'TISSUE'
        specimen = NciMatchPatientModels::Specimen.query_latest_tissue_specimen_by_patient_id(patient_id)
      else
        specimen = NciMatchPatientModels::Specimen.query_latest_blood_specimen_by_patient_id(patient_id)
      end

      specimen.received_date
    end

    def get_patient_diseases(patient_id)
      patient = NciMatchPatientModels::Patient.query_patient_by_id(patient_id)
      patient.diseases
    end

  end
end
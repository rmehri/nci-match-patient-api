module V1
  class PendingViewController < ApplicationController
    # before_action :authenticate_user
    def pending_view
      begin

        variant_reports = NciMatchPatientModels::VariantReport.find_by({:status => 'PENDING'})

        tissue_reports = []
        assignments = []
        variant_reports.each do | variant_report |
          next if variant_report.variant_report_type == 'BLOOD'
          data = {:patient_id => variant_report.patient_id,
                  :molecular_id => variant_report.molecular_id,
                  :analysis_id => variant_report.analysis_id,
                  :surgical_event_id => variant_report.surgical_event_id,
                  :ion_reporter_id => variant_report.ion_reporter_id,
                  :variant_report_received_date => variant_report.variant_report_received_date}
          data[:specimen_received_date] = get_specimen_received_date(variant_report.patient_id,
                                                                     variant_report.variant_report_type)
          tissue_reports.push(data)
        end


        assignment_reports = NciMatchPatientModels::Assignment.find_by({:status => 'PENDING'})

        assignment_reports.each do | assignment_report|
          data = {:patient_id => assignment_report.patient_id,
                  :molecular_id => assignment_report.molecular_id,
                  :analysis_id => assignment_report.analysis_id,
                  :surgical_event_id => assignment_report.surgical_event_id,
                  :assignment_date => assignment_report.assignment_date}

          data[:disease] = get_patient_diseases(assignment_report.patient_id)
          data = ApplicationHelper.merge_treatment_arm_fields(data, assignment_report.selected_treatment_arm)
          assignments.push(data)
        end

        pending_view = {:tissue_variant_reports => tissue_reports,
                        :assignment_reports => assignments}

        render json: pending_view.to_json

      rescue => error
        standard_error_message(error)
      end
    end

    def get_specimen_received_date(patient_id, type)
      specimen = nil
      if type == 'TISSUE'
        specimen = NciMatchPatientModels::Specimen.query_latest_tissue_specimen_by_patient_id(patient_id)
      else
        specimen = NciMatchPatientModels::Specimen.query_latest_blood_specimen_by_patient_id(patient_id)
      end

      if !specimen.nil? then specimen.received_date else "" end
    end

    def get_patient_diseases(patient_id)
      patient = NciMatchPatientModels::Patient.query_patient_by_id(patient_id)
      ApplicationHelper.format_disease_names(patient.diseases)
    end

  end
end
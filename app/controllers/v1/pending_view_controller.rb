module V1
  class PendingViewController < ApplicationController
    before_action :authenticate_user

    def pending_view

      AppLogger.log_debug(self.class.name, "=============================  Scanning for pending variant report")
      variant_reports = NciMatchPatientModels::VariantReport.scan_and_find_by({status: 'PENDING'})
      tissue_reports = []

      variant_reports.each do | variant_report |
        next if variant_report['variant_report_type'] == 'BLOOD'

        AppLogger.log_debug(self.class.name, "=============================  Querying for patient")
        patient = NciMatchPatientModels::Patient.query_patient_by_id(variant_report['patient_id'])
        next if (patient.current_status == "OFF_STUDY" || patient.current_status == "OFF_STUDY_BIOPSY_EXPIRED") || (patient.current_status.blank?)

        tissue_report_data = variant_report.slice('patient_id', 'molecular_id', 'analysis_id', 'surgical_event_id', 'ion_reporter_id', 'clia_lab', 'variant_report_received_date')
        patient_active_tissue = patient.active_tissue_specimen

        tissue_reports.push tissue_report_data.merge(specimen_received_date: patient_active_tissue['specimen_received_date'])
      end

      AppLogger.log_debug(self.class.name, "=============================  Done getting pending variant reports")

      #TODO
      # create pending item table
      # delete record when a pending VR changes status

      AppLogger.log_debug(self.class.name, "=============================  Scanning for pending assignment report")

      assignment_reports = NciMatchPatientModels::Assignment.scan_and_find_by({status: 'PENDING'})
      assignments = []

      assignment_reports.each do | assignment_report|

        patient = NciMatchPatientModels::Patient.query_patient_by_id(assignment_report['patient_id'])
        next if (patient.current_status == "OFF_STUDY" || patient.current_status == "OFF_STUDY_BIOPSY_EXPIRED")

        assignment_data = assignment_report.slice('patient_id', 'molecular_id', 'analysis_id', 'surgical_event_id', 'assignment_date', 'uuid').merge(disease: ApplicationHelper.format_disease_names(patient.diseases))
        assignments.push ApplicationHelper.merge_treatment_arm_fields(assignment_data, assignment_report['selected_treatment_arm'])
      end

      AppLogger.log_debug(self.class.name, "=============================  Done getting pending assignment report")
      render json: {tissue_variant_reports: tissue_reports, assignment_reports: assignments}.to_json
    end

  end
end

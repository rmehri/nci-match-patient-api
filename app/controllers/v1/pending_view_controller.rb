module V1
  class PendingViewController < ApplicationController
    before_action :authenticate_user

    def pending_view
      variant_reports = NciMatchPatientModels::VariantReport.scan_and_find_by({status: 'PENDING'})
      tissue_reports = []

      variant_reports.each do | variant_report |

        p "================ var report: #{variant_report}"


        next if variant_report['variant_report_type'] == 'BLOOD'

        p "=============================== p1"
        patient = NciMatchPatientModels::Patient.query_patient_by_id(variant_report['patient_id'])
        p "=============================== p2"

        next if (patient.current_status == "OFF_STUDY" || patient.current_status == "OFF_STUDY_BIOPSY_EXPIRED") || (patient.current_status.blank?)
        p "=============================== p3"
        tissue_report_data = variant_report.slice('patient_id', 'molecular_id', 'analysis_id', 'surgical_event_id', 'ion_reporter_id', 'clia_lab', 'variant_report_received_date')
        p "=============================== p4"
        tissue_reports.push tissue_report_data.merge(specimen_received_date: get_specimen_received_date(variant_report['patient_id'], variant_report['variant_report_type']))
      end

      assignment_reports = NciMatchPatientModels::Assignment.scan_and_find_by({status: 'PENDING'})
      assignments = []

      assignment_reports.each do | assignment_report|

        patient = NciMatchPatientModels::Patient.query_patient_by_id(assignment_report['patient_id'])
        next if (patient.current_status == "OFF_STUDY" || patient.current_status == "OFF_STUDY_BIOPSY_EXPIRED")

        assignment_data = assignment_report.slice('patient_id', 'molecular_id', 'analysis_id', 'surgical_event_id', 'assignment_date', 'uuid').merge(disease: ApplicationHelper.format_disease_names(patient.diseases))
        assignments.push ApplicationHelper.merge_treatment_arm_fields(assignment_data, assignment_report['selected_treatment_arm'])
      end

      render json: {tissue_variant_reports: tissue_reports, assignment_reports: assignments}.to_json
    end

    def get_specimen_received_date(patient_id, type)

      p "======================== type: #{type} patient id: #{patient_id}"


      specimen = (type == 'TISSUE' ? NciMatchPatientModels::Specimen.query_latest_tissue_specimen_by_patient_id(patient_id) : NciMatchPatientModels::Specimen.query_latest_blood_specimen_by_patient_id(patient_id))
      specimen.nil? ? '' : specimen.received_date
    end

  end
end

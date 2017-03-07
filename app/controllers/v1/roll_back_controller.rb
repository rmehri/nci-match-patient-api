module V1
  class RollBackController < ApplicationController
    before_action :authenticate_user
    load_and_authorize_resource :class => NciMatchPatientModelExtensions

    # PUT /api/v1/patients/:patient_id/variant_report_rollback
    def rollback_variant_report
      patient_id = get_patient_id_from_url
      p "============ patient id to roll back: #{patient_id}"
      NciMatchPatientModelExtensions::PatientExtension.roll_back_from_variant_report_action(patient_id)
      standard_success_message("Variant report roll back complete")
    end

    # PUT /api/v1/patients/:patient_id/assignment_report_rollback
    def rollback_assignment_report
      patient_id = get_patient_id_from_url
      p "============ patient id to roll back: #{patient_id}"
      NciMatchPatientModelExtensions::PatientExtension.roll_back_from_assignment_report_action(patient_id)
      standard_success_message("Assignment report roll back complete")
    end
  end
end
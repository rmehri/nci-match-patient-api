module V1
  class PatientsController < BaseController

    private
    def patient_params
      params.require(:patient_id).permit(:patient_id, :registration_date, :study_id, :gender, :ethnicity, :current_step_number, :current_status, :treating_site_id, :message)
    end

    def query_params
      parameters = params.permit(:patient_id, :registration_date, :study_id, :gender, :ethnicity, :current_step_number, :current_status, :treating_site_id, :message,
                                 :attributes, :projections, :projection => [], :attribute => [])
      build_query(parameters)
    end
  end
end
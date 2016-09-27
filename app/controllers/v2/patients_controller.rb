module V2
  class PatientsController < V2::BaseController

    private
    def patient_params
      params.require(:patient_id).permit(:registration_date)
    end

    def query_params
      parameters = params.permit(:patient_id, :registration_date, :study_id, :gender, :ethnicity, :current_step_number, :current_status, :treating_site_id, :message,
                                 :attributes, :projections, :projection => [], :attribute => [])
      build_query(parameters)
    end
  end
end
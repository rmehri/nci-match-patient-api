module V1
  class PatientsController < BaseController

    private
    def patients_params
      build_query({:patient_id => params.require(:id)})
    end

    def query_params
      parameters = params.permit(:patient_id, :registration_date, :study_id, :gender, :ethnicity, :current_step_number, :current_status, :treating_site_id, :message,
                                 :attributes, :projections, :projection => [], :attribute => [])
      build_query(parameters)
    end
  end
end
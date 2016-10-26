module V1
  class PatientsController < BaseController

    private
    def patients_params
      params.require(:id)
      params[:patient_id] = params.delete(:id)
      build_query(params.except(:action, :controller))
    end
  end
end
module V1
  class PatientsController < BaseController

    private
    def patients_params
      build_query({:patient_id => params.require(:id)})
    end

    def query_params
      build_query(params.permit!.except(:controller, :action))
    end
  end
end
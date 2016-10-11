module V1
  class PatientsController < BaseController

    private
    def patients_params
      build_query({:patient_id => params.require(:id)})
    end
  end
end
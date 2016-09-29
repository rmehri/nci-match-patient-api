module V1
  class SpecimensController < BaseController

    private
    def specimens_params
      build_query({:surgical_event_id => params.require(:id)})
    end

    def query_params
      parameters = params.permit(:patient_id, :sorting_key,
                                 :surgical_event_id, :failed_date, :study_id, :type, :collected_date,
                                 :received_date, :pathology_status, :pathology_status_date, :pathology_case_number, :variant_report_confirmed_date,
                                 :active_molecular_id, :assays,
                                 :attributes, :projections, :projection => [], :attribute => [])
      build_query(parameters)
    end
  end
end
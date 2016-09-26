module V2
  class SpecimensController < BaseController

    private
    def patient_params
      params.require(:patient_id).permit(:sorting_key)
    end

    def query_params
      parameters = params.permit(:patient_id, :sorting_key,
                                 :surgical_event_id, :failed_date, :study_id, :type, :collected_date,
                                 :received_date, :pathology_status, :pathology_status_date, :pathology_case_number, :variant_report_confirmed_date,
                                 :active_molecular_id, :assays,
                                 :projections, :projection => [], :attributes => [])
      build_query(parameters)
    end
  end
end
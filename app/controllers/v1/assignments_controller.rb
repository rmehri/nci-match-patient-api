module V1
  class AssignmentsController < BaseController

    private
    def assignments_params
      build_query({:analysis_id => params.require(:id)})
    end

    def query_params
      parameters = params.permit(:patient_id, :date_generated, :study_id, :status, :status_date, :comment, :comment_user, :report_status, :patient,
                                 :treatment_assignment_results, :step_number, :sent_to_cog_date, :received_from_cog_date,
                                 :assignment_date, :molecular_id, :analysis_id, :selected_treatment_arm,
                                 :attributes, :projections, :projection => [], :attribute => [])
      build_query(parameters)
    end

  end
end
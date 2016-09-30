module V1
  class AssignmentsController < BaseController

    def index
      begin

        plural_resource_name = "@#{resource_name.pluralize}"

        assignments_ui = []
        assignments = resource_class.scan(query_params).collect { |data| data.to_h.compact }

        assignments.each do | assignment |
          assays = find_assays(assignment[:surgical_event_id])
          assignments_ui.push(Convert::AssignmentDbModel.to_ui(assignment, assays))
        end

        instance_variable_set(plural_resource_name, assignments_ui)
        instance_variable_get(plural_resource_name)

        render json: instance_variable_get(plural_resource_name)
      rescue => error
        standard_error_message(error.message)
      end
    end

    private

    def find_assays(surgical_event_id)
      assays = []
      specimens = NciMatchPatientModels::Specimen.scan(build_query({:surgical_event_id => surgical_event_id})).collect { |data| data.to_h.compact }
      assays = specimens[0][:assays] if specimens.length > 0
      assays
    end

    def assignments_params
      build_query({:analysis_id => params.require(:id)})
    end

    def query_params
      parameters = params.permit(:patient_id, :assignment_date, :study_id, :status, :status_date, :comment, :comment_user,
                                 :report_status, :patient,
                                 :treatment_assignment_results, :step_number, :sent_to_cog_date, :received_from_cog_date,
                                 :cog_assignment_date, :molecular_id, :analysis_id, :selected_treatment_arm,
                                 :attributes, :projections, :projection => [], :attribute => [])
      build_query(parameters)
    end

  end
end
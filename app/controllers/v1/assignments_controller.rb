module V1
  class AssignmentsController < BaseController

    def index
      assignments_ui = []

      assignments = resource_class.scan(query_params).collect { |data| data.to_h.compact }
      assignments = assignments.sort_by{| assignment | assignment[:assignment_date]}.reverse

      assignments.each do | assignment |
        assays = find_assays(assignment[:surgical_event_id]) unless assignment[:surgical_event_id].blank?
        assignments_ui.push(Convert::AssignmentDbModel.to_ui(assignment, assays)) unless assignment.blank?
      end

      instance_variable_set("@#{resource_name}", assignments_ui)

      render json: instance_variable_get("@#{resource_name}")
    end

    private
    def find_assays(surgical_event_id)
      assays = []
      specimens = NciMatchPatientModels::Specimen.scan(build_index_query({:surgical_event_id => surgical_event_id})).collect { |data| data.to_h.compact }
      assays = specimens[0][:assays] if specimens.length > 0
      assays
    end

    def assignments_params
      params.require(:id)
      build_show_query(params.except(:action, :controller), :analysis_id)
    end

  end
end
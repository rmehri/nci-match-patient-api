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

  end
end
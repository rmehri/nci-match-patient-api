module V1
  class AssignmentsController < BaseController
    before_action :resource_scan, only: [:index]

    def index
      begin
        assignments_ui = []
        get_resource.each do | assignment |
          assays = find_assays(assignment[:surgical_event_id]) unless assignment[:surgical_event_id].blank?
          assignments_ui.push(Convert::AssignmentDbModel.to_ui(assignment, assays))
        end
        instance_variable_set("@#{resource_name}", assignments_ui)
        render json: instance_variable_get("@#{resource_name}")
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

  end
end
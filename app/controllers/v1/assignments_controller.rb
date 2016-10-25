module V1
  class AssignmentsController < BaseController

  #   def index
  #     plural_resource_name = "@#{resource_name.pluralize}"
  #     assignments_ui = []
  #     resources = resource_class.scan(query_params).collect { |data| data.to_h.compact }
  #     resources.each do | resource |
  #       resource = find_assays(assignment[:surgical_event_id]) unless assignment[:surgical_event_id].blank?
  #       assignments_ui.push(Convert::AssignmentDbModel.to_ui(assignment, assays)) unless assignment.blank?
  #     end
  #     instance_variable_set(plural_resource_name, assignments_ui)
  #     render json: instance_variable_get(plural_resource_name)
  #   end
  #
  #   private
  #   def find_assays(surgical_event_id)
  #     assays = []
  #     specimens = NciMatchPatientModels::Specimen.scan(build_query({:surgical_event_id => surgical_event_id})).collect { |data| data.to_h.compact }
  #     assays = specimens[0][:assays] if specimens.length > 0
  #     assays
  #   end
  #
  #   def assignments_params
  #     build_query({:analysis_id => params.require(:id)})
  #   end
  #
  # end

    def index
      begin
        assignments_ui = []

        assignments = resource_class.scan(query_params).collect { |data| data.to_h.compact }

        assignments.each do | assignment |
          assays = find_assays(assignment[:surgical_event_id]) unless assignment[:surgical_event_id].blank?
          assignments_ui.push(Convert::AssignmentDbModel.to_ui(assignment, assays)) unless assignment.blank?
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

    # def resource_scan(params = {})
    #   assignments = NciMatchPatientModels::Assignment.find_by({:analysis_id => params[:analysis_id]}).collect{ |data| data.to_h.compact}
    #   sorted = assignments.sort_by {| assignment| assignment[:assignment_date]}.reverse
    #
    # end

  end
end
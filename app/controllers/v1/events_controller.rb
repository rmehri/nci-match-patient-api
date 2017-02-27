module V1
  class EventsController < BaseController

    def index
      plural_resource_name = "@#{resource_name.pluralize}"
      resources = resource_class.scan(query_params).collect { |data| data.to_h.compact }
      resources.sort_by!{ |record| record[:event_date]} unless !params.has_key?(:order)
      resources.reverse! if (params.has_key?(:order) && params[:order].downcase == 'desc')
      resources = resources.take(params[:num].to_i) unless !params.has_key?(:num)
      instance_variable_set(plural_resource_name, resources)
      render json: instance_variable_get(plural_resource_name)
    end

    def create
      authorize! :create_event, :EVENT
      message = JSON.parse(request.raw_post)
      errors = MessageValidator.validate_json_message("Event", message)
      raise Errors::RequestForbidden, errors unless errors.blank?
      results = PatientProcessor.run_service(:EVENT, message)
      standard_success_message(results)
    end

    private
    def events_params
      params.require(:id)
      build_show_query(params.except(:action, :controller), :entity_id)
    end

  end
end
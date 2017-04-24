module V1
  class EventsController < BaseController
    # load_and_authorize_resource :class => NciMatchPatientModels, :only => [:create]

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
      authorize! :create, :Event
      message = JSON.parse(request.raw_post)
      em = EventMessage.new.from_json(message.to_json)
      raise Errors::RequestForbidden, em.errors unless em.valid?
      results = PatientProcessor.run_service("/upload_event", message, request.uuid, token)
      standard_success_message(results)
    end

    private
    def events_params
      params.require(:id)
      build_show_query(params.except(:action, :controller), :entity_id)
    end

  end
end
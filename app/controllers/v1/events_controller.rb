module V1
  class EventsController < BaseController

    def index
      plural_resource_name = "@#{resource_name.pluralize}"
      resources = resource_class.scan(query_params).collect { |data| data.to_h.compact }
      resources.sort_by!{ |record| record[:event_date]} unless !params.has_key?(:order)
      resources.reverse! if (params.has_key?(:order) && params[:order] == 'desc')
      resources = resources.take(params[:num].to_i) unless !params.has_key?(:num)
      instance_variable_set(plural_resource_name, resources)
      render json: instance_variable_get(plural_resource_name)
    end

    private
    def events_params
      build_query({:entity_id => params.require(:id)})
    end

  end
end
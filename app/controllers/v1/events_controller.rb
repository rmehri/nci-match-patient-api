module V1
  class EventsController < BaseController

    private
    def events_params
      build_query({:entity_id => params.require(:id)})
    end

    def query_params
      parameters = params.permit!.except(:controller, :action)
      build_query(parameters)
    end
  end
end
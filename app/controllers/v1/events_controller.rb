module V1
  class EventsController < BaseController

    private
    def events_params
      build_query({:entity_id => params.require(:id)})
    end

    def query_params
      parameters = params.permit(:entity_id, :event_date, :event_type, :event_message, :event_data,
                                 :attributes, :projections, :projection => [], :attribute => [])
      build_query(parameters)
    end
  end
end
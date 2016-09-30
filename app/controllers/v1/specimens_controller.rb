module V1
  class SpecimensController < BaseController

    private
    def specimens_params
      build_query({:surgical_event_id => params.require(:id)})
    end

    def query_params
      build_query(params.permit!.except(:controller, :action))
    end
  end
end
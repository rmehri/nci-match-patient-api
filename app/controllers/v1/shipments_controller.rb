module V1
  class ShipmentsController < BaseController

    private
    def shipments_params
      build_query({:molecular_id => params.require(:id)})
    end

    def query_params
      build_query(params.permit!.except(:controller, :action))
    end
  end
end
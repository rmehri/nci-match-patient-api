module V1
  class ShipmentsController < BaseController

    private
    def shipments_params
      build_query({:molecular_id => params.require(:id)})
    end

  end
end
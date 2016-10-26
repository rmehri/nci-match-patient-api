module V1
  class ShipmentsController < BaseController

    private
    def shipments_params
      params.require(:id)
      params[:molecular_id] = params.delete(:id)
      build_query({:molecular_id => params.require(:id)})
    end

  end
end
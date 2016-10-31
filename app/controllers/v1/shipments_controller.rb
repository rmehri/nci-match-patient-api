module V1
  class ShipmentsController < BaseController

    private
    def shipments_params
      build_query({:molecular_id => params.require(:id)})
      # params.require(:id)
      # # params[:molecular_id] = params.delete(:id)
      # build_query(params.except(:action, :controller))
    end

  end
end
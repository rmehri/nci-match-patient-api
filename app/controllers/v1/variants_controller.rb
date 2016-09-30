module V1
  class VariantsController < BaseController


    private
    def variants_params
      build_query({:analysis_id => params.require(:id)})
    end

    def query_params
      build_query(params.permit!.except(:controller, :action))
    end

  end
end
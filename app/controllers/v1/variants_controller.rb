module V1
  class VariantsController < BaseController


    private
    def variants_params
      build_query({:analysis_id => params.require(:id)})
    end

  end
end
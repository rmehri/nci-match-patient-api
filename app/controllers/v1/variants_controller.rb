module V1
  class VariantsController < BaseController


    private
    def variants_params
      params.require(:id)
      params[:analysis_id] = params.delete(:id)
      build_query(params.except(:action, :controller))
    end

  end
end
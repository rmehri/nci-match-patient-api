module V1
  class SpecimensController < BaseController

    private
    def specimens_params
      params.require(:id)
      params[:surgical_event_id] = params.delete(:id)
      build_query(params.except(:action, :controller))
    end

  end
end
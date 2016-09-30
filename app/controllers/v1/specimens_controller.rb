module V1
  class SpecimensController < BaseController

    private
    def specimens_params
      build_query({:surgical_event_id => params.require(:id)})
    end

  end
end
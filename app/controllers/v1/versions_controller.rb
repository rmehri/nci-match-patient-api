module V1
  class VersionsController < ApplicationController

    def version
      render json: NciMatchPatientApi::Application.VERSION
    end

  end
end

class VersionController < ApplicationController

  def version
    begin
      render json: NciMatchPatientApi::Application.VERSION
    rescue => error
      standard_error_message(error)
    end

  end

end
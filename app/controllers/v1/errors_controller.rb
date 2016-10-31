module V1
  class ErrorsController < ApplicationController
    def show
      render :json => {:message => params[:error_message], :status => status_code}, :status => status_code
    end

    protected
    def status_code
      params[:id] || 500
    end

  end
end
module V1
  class ErrorsController < ApplicationController

    def bad_request
      respond_to do |format|
        format.json { render :json => {:message => "Bad Request"}, :layout => false, :status => :bad_request }
        format.any { head :bad_request }
      end
    end

  end
end

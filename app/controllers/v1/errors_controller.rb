module V1
  class ErrorsController < ApplicationController

    def not_acceptable
      respond_to do |format|
        format.json { render :json => {:message => "Not Acceptable"}, :layout => false, :status => :not_acceptable }
        format.any { head :not_acceptable }
      end
    end

  end
end
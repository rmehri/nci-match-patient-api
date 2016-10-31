module V1
  class ErrorsController < ApplicationController

    def raise_not_found
      raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
    end

    def not_found
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
        format.xml { head :not_found }
        format.any { head :not_found }
      end
    end

    def error
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/500", :layout => false, :status => :error }
        format.xml { head :not_found }
        format.any { head :not_found }
      end
    end

    protected
    def status_code
      params[:id] || 500
    end

  end
end
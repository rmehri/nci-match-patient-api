class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  protected
  def standard_error_message(error)
    AppLogger.log_error(ApplicationController, error.message)
    render :json => {:status => "Failure" ,:error => error.message}, :status => 500
  end
end

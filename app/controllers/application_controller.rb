class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  protected
  def standard_success_message(message)
    render :json => {:message => message}, :status => 200
  end

  def standard_error_message(error_message, error_code=500)

    AppLogger.log_error(self.class.name, error_message)
    render status: error_code, json: {:message => error_message}
  end

  def get_url_path_segments
    return request.fullpath.split("/")
  end
end

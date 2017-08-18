module V1
  class UsersController < ApplicationController
    before_action :authenticate_user

    def update
      authorize! :user_update, NciMatchPatientModels
      Auth0Service.get_management_token
      response = Auth0Service.update_password(current_user[:sub], params[:password])

      # print auth0 response only if update failed
      response_message = response.code.ok? ? 'Password changed successfully!' : response.parsed_response

      render json: {message: response_message}, status: response.code
    end
  end
end

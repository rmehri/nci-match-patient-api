module V1
  class UsersController < ApplicationController
    before_action :authenticate_user
    before_action :users_params, only: :update

    def update
      authorize! :user_update, NciMatchPatientModels
      Auth0Service.get_management_token
      response = Auth0Service.update_password(current_user[:sub], params[:password])
      render json: response.parsed_response, status: response.code
    end

    def users_params
      params.require(:password)
    end
  end
end

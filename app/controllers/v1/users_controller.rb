module V1
  class UsersController < ApplicationController
    before_action :authenticate_user
    before_action :users_params, only: :update

    def update
      authorize! :user_update, "ADMIN".to_sym
      Auth0Service.get_management_token
      Auth0Service.reset_password(current_user[:sub], params[:password])
    end

    def users_params
      params.require(:password)
    end
  end
end
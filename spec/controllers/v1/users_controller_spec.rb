require 'rails_helper'


RSpec.describe V1::UsersController, type: :controller do

  it 'should route to the correct controller' do
    expect(patch: 'api/v1/patients/users').to route_to(controller: 'v1/users', action: 'update')
  end


  # it "successfully update password" do
  #   allow(Auth0Service).to receive(:get_management_token).and_return(true)
  #   allow(Auth0Service).to receive(:update_password).and_return(200)
  #   patch :update, password: "password"
  #   expect(response.status).to eq(200)
  # end
  # it "fail due to auth0" do
  #   allow(Auth0Service).to receive(:get_management_token).and_return({})
  #   allow(Auth0Service).to receive(:update_password).and_return(401)
  #   patch :update, password: "password"
  #   p response
  # end

end
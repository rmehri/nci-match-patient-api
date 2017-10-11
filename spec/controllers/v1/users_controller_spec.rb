require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do
  it 'should route to the correct controller' do
    expect(patch: 'api/v1/patients/users').to route_to(controller: 'v1/users', action: 'update')
  end

  it "successfully update password" do
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(200)

    allow(Auth0Service).to receive(:get_management_token)
    allow(Auth0Service).to receive(:update_password).and_return(HTTParty::Response.new)
    patch :update, params: {password: "password"}, as: :json
    expect(response.status).to eq(200)
    expect(response.body).to eq({message: 'Password changed successfully!'}.to_json)
  end

  it "fail to update password" do
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(401)
    allow(HTTParty::Response).to receive(:parsed_response).and_return('Failed!')

    allow(Auth0Service).to receive(:get_management_token).and_return({})
    allow(Auth0Service).to receive(:update_password).and_return(HTTParty::Response.new)
    patch :update, params: {password: "password"}, as: :json
    expect(response.status).to eq(401)
    expect(response.body).to eq({message: 'Failed!'}.to_json)
  end
end

require 'rails_helper'

RSpec.describe Auth0Service do

  it 'should respond with 400' do
    expect(Auth0Service.update_password("test_user", "password").code).to eq(400)
  end

  it 'should get the management_token' do
    # mock request/response
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)

    # mock token
    allow(HTTParty::Response).to receive(:body).and_return({access_token: 'token'}.to_json)
    expect(Auth0Service.get_management_token).to eq('token')
  end

  it "update_password will fail gracefully" do
    allow(HTTParty::Request).to receive(:new).and_raise(Errors::RequestForbidden)
    expect{Auth0Service.update_password("test_user", "password")}.to raise_error(Errors::RequestForbidden)
  end

  it "get_management_token will fail gracefully" do
    allow(HTTParty::Request).to receive(:new).and_raise(URI::InvalidURIError)
    expect{Auth0Service.get_management_token}.to raise_error(URI::InvalidURIError)
  end

  it "should successfully update password" do
    # mock request/response
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)

    # mock token
    allow(HTTParty::Response).to receive(:body).and_return({access_token: 'token'}.to_json)

    # mock valid response
    allow(HTTParty::Response).to receive(:code).and_return(200)
    expect(Auth0Service.update_password("fake_user", "password").code).to eq(200)
  end

end

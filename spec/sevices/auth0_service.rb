require 'rails_helper'

RSpec.describe Auth0Service do

  it{expect(Auth0Service.update_password("test_user", "password")).to eq(400)}
  it{expect(Auth0Service.get_management_token).to be_truthy}
  it{expect{Auth0Service.management_token}.to raise_error(NoMethodError)}

  it "update_password will fail gracefully" do
    allow(HTTParty::Request).to receive(:new).and_raise(Errors::RequestForbidden)
    expect{Auth0Service.update_password("test_user", "password")}.to raise_error(Errors::RequestForbidden)
  end

  it "get_management_token will fail gracefully" do
    allow(HTTParty::Request).to receive(:new).and_raise(URI::InvalidURIError)
    expect{Auth0Service.get_management_token}.to raise_error(URI::InvalidURIError)
  end

  it "successfully update password" do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(200)
    expect(Auth0Service.update_password("fake_user", "password")).to eq(200)
  end

end
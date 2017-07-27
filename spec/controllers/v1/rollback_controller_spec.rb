require 'rails_helper'


describe V1::RollbackController, type: :controller do

  it {expect(:put => "api/v1/patients/123/rollback").to route_to(:controller => "v1/rollback", :action => "rollback", :patient_id => "123")}

  it "PUT#rollback failed" do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(400)
    allow(HTTParty::Response).to receive(:body).and_return("")

    expect(response).to have_http_status(403)
  end

  it "PUT#rollback success" do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(200)
    allow(HTTParty::Response).to receive(:body).and_return(true)
    put :rollback, :patient_id => "123"
    expect(response).to have_http_status(204)
  end

end

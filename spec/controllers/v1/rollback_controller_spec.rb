require 'rails_helper'


describe V1::RollbackController, type: :controller do

  it {expect(:put => "api/v1/patients/123/variant_report_rollback").to route_to(:controller => "v1/rollback", :action => "variant_report", :patient_id => "123")}
  it {expect(:put => "api/v1/patients/123/assignment_report_rollback").to route_to(:controller => "v1/rollback", :action => "assignment_report", :patient_id => "123")}

  it "PUT#variant_report_rollback failed" do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(400)
    allow(HTTParty::Response).to receive(:body).and_return("")
    put :variant_report, :patient_id => "123"
    expect(response).to have_http_status(403)
  end

  it "PUT#variant_report_rollback success" do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(200)
    allow(HTTParty::Response).to receive(:body).and_return(true)
    put :variant_report, :patient_id => "123"
    expect(response).to have_http_status(204)
  end

  it "PUT#assignment_report failed" do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(400)
    allow(HTTParty::Response).to receive(:body).and_return("")
    put :assignment_report, :patient_id => "123"
    expect(response).to have_http_status(403)
  end

  it "PUT#assignment_report success" do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(200)
    allow(HTTParty::Response).to receive(:body).and_return({statue: "true"})
    put :variant_report, :patient_id => "123"
    expect(response).to have_http_status(204)
  end

end
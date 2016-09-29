require 'rails_helper'
require 'factory_girl_rails'
require 'httparty/response'
require 'httparty/request'

describe TreatmentArmApi do

  it "should return treatment_arm json" do
    treatment_arms = {"treatment_arm_id" => "TA_1", "status" => "OPEN"}

    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(200)
    allow(HTTParty::Response).to receive(:body).and_return(treatment_arms)

    returned_tas = TreatmentArmApi.get_treatment_arms
    expect(returned_tas.to_s).to include("TA_1")

  end

  it "should raise exception because response code is not 200" do

    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(500)

    expect{(TreatmentArmApi.get_treatment_arms)}.to raise_error(RuntimeError)
  end
end

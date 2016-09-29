require 'rails_helper'
require 'factory_girl_rails'
require 'httparty/response'
require 'httparty/request'

describe RuleEngine do

  it "should return mois json" do
    treatment_arms = [{"treatment_arm_id" => "TA_1", "status" => "OPEN"}]
    mois = {:ion_reporter_id => "7788", :molecular_id => "mole_id"}

    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(200)
    allow(HTTParty::Response).to receive(:body).and_return(mois)

    returned_mois = RuleEngine.get_mois("patient_id", "ion_id", "mole_id", "an_id", "test.tsv", treatment_arms)
    expect(returned_mois.to_s).to include("7788")

  end

  it "should raise exception because response code is not 200" do

    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(500)

    expect{(RuleEngine.get_mois("patient_id", "ion_id", "mole_id", "an_id", "test.tsv", []))}.to raise_error(RuntimeError)
  end
end
require 'rails_helper'
require 'factory_girl_rails'
require 'aws-record'

describe V1::ServicesController do

  before(:each) do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Request).to receive(:perform).and_return(true)
  end

  let(:good_message) do
    {
        "header"=> {
            "msg_guid" => "0f8fad5b-d9cb-469f-al65-80067728950e",
            "msg_dttm"=> "2016-05-09T22:06:33+00:00"
        },
        "study_id"=> "APEC1621",
        "patient_id"=> "3344",
        "step_number"=> "1.0",
        "registration_date"=> "2016-05-09T22:06:33+00:00",
        "status"=> "REGISTRATION",
        "internal_use_only"=> {
            "request_id"=> "4-654321",
            "environment"=> "4",
            "request"=> "REGISTRATION for patient_id 2222"
        }
    }.to_json
  end

  it "should route to correct controller" do
    expect(:post => "api/v1/patients/3355").to route_to(:controller => "v1/services", :action => "trigger", :patient_id =>"3355")
  end

  it "POST /trigger" do
    expect(:post => "api/v1/patients/1").to route_to(:controller => "v1/services", :action => "trigger", :patient_id => "1")
  end

  #   allow(Aws::Sqs::Publisher).to receive(:publish).and_return("")
  #
  #   # allow(Aws::Sqs::Publisher).to receive(:publish).and_return("")
  #   # put :assignment_reports, :patient_id => "1", :date_assigned => "123456"
  #
  #   post :trigger, good_message
  #   # good_message
  #
  #   # headers = { 'CONTENT_TYPE' => 'application/json' }
  #   #
  #   # post "/api/v1/patients/3355", good_message, headers
  #
  #   expect {
  #     JSON.parse(response.body)
  #   }.to_not raise_error
  # end
end
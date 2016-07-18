require 'rails_helper'
require 'factory_girl_rails'
require 'aws-record'

describe ServicesController do

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
    expect(:post => "trigger").to route_to(:controller => "services", :action => "trigger")
  end

  # it "POST /trigger" do
  #   message = JSON.parse(good_message)
  #   message.deep_transform_keys!(&:underscore).symbolize_keys!
  #
  #   allow(Aws::Sqs::Publisher).to receive(:publish).and_return("")
  #   post :trigger, valid_test_message
  #
  #   expect {
  #     JSON.parse(response.body)
  #   }.to_not raise_error
  # end
end
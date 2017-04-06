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
        "study_id"=> "APEC1621SC",
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

  # it "should process a registration message" do
  #   # post "api/v1/patients/1", good_message
  #
  #   expect(post "api/v1/patients/1", good_message).to have_http_status(200)
  # end


  it "should route to correct controller" do
    expect(:post => "api/v1/patients/3355").to route_to(:controller => "v1/services", :action => "trigger", :patient_id =>"3355")
  end

  it "POST /trigger" do
    expect(:post => "api/v1/patients/1").to route_to(:controller => "v1/services", :action => "trigger", :patient_id => "1")
    expect(:post => "api/v1/patients/variant_report/1").to route_to(:controller => "v1/services", :action => "variant_report_uploaded", :molecular_id => "1")

    expect(:put => "api/v1/patients/1/variant_reports/aid/confirm").to route_to(:controller => "v1/services",
                                                                           :action => "variant_report_status",
                                                                            :patient_id => "1",
                                                                                    :analysis_id => "aid",
                                                                             :status => "confirm")

    expect(:put => "api/v1/patients/variant/123456/unchecked").to route_to(:controller => "v1/services", :action => "variant_status",
                                                                                     :variant_uuid => "123456", :status => "unchecked")
    expect(:put => "api/v1/patients/1/assignment_reports/aid/confirm").to route_to(:controller => "v1/services",
                                                                               :action => "assignment_confirmation",
                                                                               :patient_id => "1",
                                                                                   :analysis_id => "aid",
                                                                                   :status => "confirm")
  end

end
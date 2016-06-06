require 'rails_helper'
require 'factory_girl_rails'

describe PatientsController do

  # before(:each) do
  #   setup_knock()
  # end

  let(:patient_dbm) do
    assignemnt_report = nil

    stub_model Patient,
      :patient_id           => 'PAT123',
      :registration_date    => '2016-05-09T22:06:33+00:00',
      :study_id             => 'APEC1621',
      :gender               => 'MALE',
      :ethnicity            => 'WHITE',
      :races                => ["WHITE", "HAWAIIAN"],
      :current_step_number  => "1.0",
      :current_assignment   => assignemnt_report,
      :current_status       => "REGISTRATION",
      :disease              => {
          "name"              => "Invasive Breast Carcinoma",
          "ctep_category"     => "Breast Neoplasm",
          "ctep_sub_category" => "Breast Cancer - Invasive",
          "ctep_term"         => "Invasive Breast Carcinoma",
          "med_dra_code"      => "1000961"
      },
      :prior_drugs          => ["Aspirin", "Motrin", "Vitamin C"],
      :documents            => {"list" =>[
          {
              "name" => "Document 1",
              "uploadedDate" => "2016-05-09T22:06:33+00:00",
              "user" => "James Bond"
          },
          {
              "name" => "Document 2",
              "uploadedDate" => "2016-05-09T22:06:33+00:00",
              "user" => "James Bond"
          },
          {
              "name" => "X-File A23FSD34",
              "uploadedDate" => "2016-05-09T22:06:33+00:00",
              "user" => "Fox Mulder"
          }
      ]}
        
  end

  let(:patient_event_dbm) do
    stub_model PatientEvent,
               :patient_id     => 'PAT123',
               :event_date     => '2016-05-09T22:06:33+00:00',
               :event_name     => 'Event Name 1',
               :event_type     => 'TYPE1',
               :event_message  => 'Message1',
               :event_data     => { "status" => "Pending", "biopsy_sequence_number" => "B-987456" }
  end

  it "route to correct controller" do
    expect(:get => "/patients" ).to route_to(:controller => "patients", :action => "index")
    expect(:get => "/patients/1" ).to route_to(:controller => "patients", :action => "show", :id => "1")
    expect(:get => "/patients/1/timeline" ).to route_to(:controller => "patients", :action => "timeline", :id => "1")
  end

  let(:patient_list_dbm) do
    stub_model PatientEvent,
               :patient_id     => 'PAT123',
               :event_date     => '2016-05-09T22:06:33+00:00',
               :event_name     => 'Event Name 1',
               :event_type     => 'TYPE1',
               :event_message  => 'Message1',
               :event_data     => { "status" => "Pending", "biopsy_sequence_number" => "B-987456" }
  end

  it "route to correct controller" do
    expect(:get => "/patients" ).to route_to(:controller => "patients", :action => "index")
    expect(:get => "/patients/1" ).to route_to(:controller => "patients", :action => "show", :id => "1")
    expect(:get => "/patients/1/timeline" ).to route_to(:controller => "patients", :action => "timeline", :id => "1")
  end

  xit "GET /patients to return json list of patients" do
    get :index, format: :json

    expect(response).to have_http_status(200)

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "GET /patients/1 to return json patient" do
    allow(Patient).to receive(:scan).and_return(patient_dbm)

    get :show, :id => "2222"

    expect(response).to have_http_status(200)

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "GET /patients/1/timeline to return json patient timeline" do
    allow(PatientEvent).to receive(:scan).and_return(patient_event_dbm)

    get :timeline, :id => "1", format: :json

    expect(response).to have_http_status(200)

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "POST /patients/1/variantreport/ to return 400 for invalid json" do
  end

  it "POST /patients/1/variantreport/ to return 422 for if state machine doesn't validate" do
  end

  it "POST /patients/1/variantreport/ to return 200 for valid json and state machine can validate" do
  end

end
require 'rails_helper'
require 'factory_girl_rails'
require 'aws-record'
require 'nci_match_patient_models'

describe V1::PatientsController do

  # before(:each) do
  #   setup_knock()
  # end

  before(:each) do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Request).to receive(:perform).and_return(true)
  end

  let(:patient_dbm) do
    assignemnt_report = nil

    stub_model NciMatchPatientModels::Patient,
               :patient_id => 'PAT123',
               :registration_date => '2016-05-09T22:06:33+00:00',
               :study_id => 'APEC1621',
               :gender => 'MALE',
               :ethnicity => 'WHITE',
               :races => ["WHITE", "HAWAIIAN"],
               :current_step_number => "1.0",
               :current_assignment => assignemnt_report,
               :current_status => "REGISTRATION",
               :disease => {
                   "name" => "Invasive Breast Carcinoma",
                   "ctep_category" => "Breast Neoplasm",
                   "ctep_sub_category" => "Breast Cancer - Invasive",
                   "ctep_term" => "Invasive Breast Carcinoma",
                   "med_dra_code" => "1000961"
               },
               :prior_drugs => ["Aspirin", "Motrin", "Vitamin C"],
               :documents => {"list" => [
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

  it "model from gem should include Aws::Record" do
    expect(NciMatchPatientModels::Patient.include?(Aws::Record)).to be true
  end

  it "route to correct controller" do
    expect(:get => "api/v1/patient/patients").to route_to(:controller => "v1/patients", :action => "index")
    expect(:get => "api/v1/patient/patients/1").to route_to(:controller => "v1/patients", :action => "show", :id => "1")
  end

  let(:patient_list_dbm) do
    stub_model NciMatchPatientModels::Event,
               :patient_id => 'PAT123',
               :event_date => '2016-05-09T22:06:33+00:00',
               :event_name => 'Event Name 1',
               :event_type => 'TYPE1',
               :event_message => 'Message1',
               :event_data => {"status" => "Pending", "biopsy_sequence_number" => "B-987456"}
  end

  it "route correctly" do
    expect(:get => "api/v1/patient/patients/1/variant_reports").to route_to(:controller => "v1/variant_reports", :action => "index",
                                                           :patient_id => "1")
    expect(:get => "api/v1/patient/patients/1/assignments").to route_to(:controller => "v1/assignments", :action => "index",
                                                                       :patient_id => "1")
    expect(:get => "api/v1/patient/patients/1/assignments/1234567").to route_to(:controller => "v1/assignments", :action => "show",
                                                                               :patient_id => "1", :id => "1234567")
  end


  it "GET /patients to return json list of patients" do
    allow(NciMatchPatientModels::Patient).to receive(:scan).and_return([patient_dbm, patient_dbm])

    get :index, format: :json

    expect(response).to have_http_status(200)

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "GET /patients/1 to return json patient" do
    allow(NciMatchPatientModels::Patient).to receive(:scan).and_return([patient_dbm])

    get :show, :id => "2222"

    expect(response).to have_http_status(200)

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "GET /patients/1 should handle errors by returning status 500" do
    allow(NciMatchPatientModels::Patient).to receive(:scan).and_raise("An Error")

    get :show, :id => "2222"

    expect(response).to have_http_status(500)
    expect(response.body).to include "message"
  end

  it "GET /patients/1 only allow specified params to be queried" do
    get :show, :id => "23413"
    expect(controller.params[:id]).not_to be_nil
  end

  it "GET /patients remove params that aren't allowed" do
    controller = V1::PatientsController.new
    controller.params = {:random => "random", :patient_id => "3344"}
    expect(controller.send(:query_params)).not_to include(:random)
  end

  it 'should return an assignment report based on analysis id' do
    assignment = NciMatchPatientModels::Assignment.new
    allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([assignment])

    get :show, :id => "2222"

    expect(response).to have_http_status(200)

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end



end
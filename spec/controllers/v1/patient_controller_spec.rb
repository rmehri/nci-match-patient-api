require 'rails_helper'
require 'factory_girl_rails'
require 'aws-record'
require 'nci_match_patient_models'

describe V1::PatientsController, :type => :controller do

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
               :study_id => 'APEC1621SC',
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
    expect(:get => "api/v1/patients").to route_to(:controller => "v1/patients", :action => "index")
    expect(:get => "api/v1/patients/1").to route_to(:controller => "v1/patients", :action => "show", :id => "1")
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

  it "GET /patients to return json list of patients" do
    allow(NciMatchPatientModels::Patient).to receive(:scan).and_return([patient_dbm, patient_dbm])

    get :index, format: :json

    expect(response).to have_http_status(200)

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "GET /patients/1 to return json patient" do
    allow(NciMatchPatientModels::Patient).to receive(:query).and_return([patient_dbm])

    get :show, :id => "2222"

    expect(response).to have_http_status(200)

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "GET /patients/1 should handle errors by returning status 500" do
    allow(NciMatchPatientModels::Patient).to receive(:scan).and_raise("Valid Error")

    expect(get :show, :id => "2222").to have_http_status(404)
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

  # it 'should return an assignment report based on analysis id' do
  #   assignment = NciMatchPatientModels::Assignment.new
  #   allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([assignment])
  #
  #   get :show, :id => "2222"
  #
  #   expect(response).to have_http_status(200)
  #
  #   expect {
  #     JSON.parse(response.body)
  #   }.to_not raise_error
  # end



  it "#create should accept registration message" do
    registration_message = {
        "header": {
            "msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
            "msg_dttm": "2016-05-09T22:06:33+00:00"
        },
        "study_id": "APEC1621SC",
        "patient_id": "3366",
        "step_number": "1.0",
        "status_date": "2016-05-09T22:06:33+00:00",
        "status": "REGISTRATION",
        "internal_use_only": {
            "request_id": "4-654321",
            "environment": "4",
            "request": "REGISTRATION for patient_id 2222"
        }
    }
    allow(StateMachine).to receive(:validate).and_return('true')
    allow(Aws::Sqs::Publisher).to receive(:publish).and_return(true)
    expect(post :create, registration_message.to_json).to have_http_status(200)
  end

  it "#create should fail validation for registration message" do
    registration_message = {
        "header": {
            "msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
            "msg_dttm": "2016-05-09T22:06:33+00:00"
        },
        "study_id": "APEC1621SC",
        "patient_id": "3366",
        "step_number": "1.0",
        "status_date": "2016-05-09T22:06:33+00:00",
        "status": "REGISTRATION",
    }
    post :create, registration_message.to_json
    expect(response).to have_http_status(500)
  end

  it "#create variant report success when all data is present" do
    variant_message = {
        "patient_id": "3344",
        "ion_reporter_id": "MoCha",
        "molecular_id": "3366-bsn-msn-2",
        "analysis_id": "job1",
        "tsv_file_name": "3366.tsv"
    }
    allow(StateMachine).to receive(:validate).and_return('true')
    allow(NciMatchPatientModels::Shipment).to receive(:find_by).and_return([{:random => "data"}])
    allow(Aws::Sqs::Publisher).to receive(:publish).and_return(true)
    expect(post :create, variant_message.to_json).to have_http_status(200)
  end

  it "#create should throw error when message is unknown" do
    expect(post :create, {"unknown": "unknown"}.to_json).to have_http_status(404)
  end

  it '#update should throw an route error' do
    expect { patch :update, :id => 1}.to raise_error(ActionController::UrlGenerationError)
  end

  it '#delete should throw an route error' do
    expect { delete :destroy, :id => 1}.to raise_error(ActionController::UrlGenerationError)
  end

end
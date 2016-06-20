require 'rails_helper'
require 'factory_girl_rails'

describe PatientsController do

  # before(:each) do
  #   setup_knock()
  # end

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

  let(:patient_event_dbm) do
    stub_model NciMatchPatientModels::PatientEvent,
               :patient_id => 'PAT123',
               :event_date => '2016-05-09T22:06:33+00:00',
               :event_name => 'Event Name 1',
               :event_type => 'TYPE1',
               :event_message => 'Message1',
               :event_data => {"status" => "Pending", "biopsy_sequence_number" => "B-987456"}
  end


  it "model from gem should include Aws::Record" do

    # p "!!!!!!!!!!!!!!!!!!!"
    # p NciMatchPatientModels::Patient.instance_methods(true)
    # p NciMatchPatientModels::Patient.methods.grep(/table_name/)

    # o = NciMatchPatientModels::Patient.new

    # o.table_name = 'blah'

    # p o.table_name
    # p "NciMatchPatientModels::Patient.table_name"
    # NciMatchPatientModels::Patient.set_table_name "blah"
    # p NciMatchPatientModels::Patient.table_name
    #
    # p ENV["table_prefix"].to_s
    # p ENV["table_suffix"].to_s

    expect(NciMatchPatientModels::Patient.include?(Aws::Record)).to be true
  end


  it "route to correct controller" do
    expect(:get => "/patients").to route_to(:controller => "patients", :action => "patient_list")
    expect(:get => "/patients/1").to route_to(:controller => "patients", :action => "patient", :patientid => "1")
    expect(:get => "/patients/1/timeline").to route_to(:controller => "patients", :action => "timeline", :patientid => "1")
  end

  let(:patient_list_dbm) do
    stub_model NciMatchPatientModels::PatientEvent,
               :patient_id => 'PAT123',
               :event_date => '2016-05-09T22:06:33+00:00',
               :event_name => 'Event Name 1',
               :event_type => 'TYPE1',
               :event_message => 'Message1',
               :event_data => {"status" => "Pending", "biopsy_sequence_number" => "B-987456"}
  end

  it "route correctly" do
    expect(:get => "/patients").to route_to(:controller => "patients", :action => "patient_list")
    expect(:get => "/patients/1").to route_to(:controller => "patients", :action => "patient", :patientid => "1")
    expect(:get => "/patients/1/timeline").to route_to(:controller => "patients", :action => "timeline", :patientid => "1")
    expect(:get => "/patients/1/sampleHistory/2").to route_to(:controller => "patients", :action => "sample", :patientid => "1", :sampleid => "2")
    expect(:post => "/registration").to route_to(:controller => "patients", :action => "registration")
    expect(:post => "/specimenReceipt").to route_to(:controller => "patients", :action => "specimen_receipt")
    expect(:post => "/assayOrder").to route_to(:controller => "patients", :action => "assay_order")
    expect(:post => "/assayResult").to route_to(:controller => "patients", :action => "assay_result")
    expect(:post => "/pathologyStatus").to route_to(:controller => "patients", :action => "pathology_status")
    expect(:post => "/variantResult").to route_to(:controller => "patients", :action => "variant_result")
    expect(:post => "/patients/1/sampleFile").to route_to(:controller => "patients", :action => "sample_file", :patientid => "1")
    expect(:put => "/patients/1/variantStatus").to route_to(:controller => "patients", :action => "variant_status", :patientid => "1")
    expect(:put => "/patients/1/variantReportStatus").to route_to(:controller => "patients", :action => "variant_report_status", :patientid => "1")
    expect(:post => "/patients/1/assignmentConfirmation").to route_to(:controller => "patients", :action => "assignment_confirmation", :patientid => "1")
    expect(:post => "/patientStatus").to route_to(:controller => "patients", :action => "patient_status")
    expect(:get => "/patients/1/documents").to route_to(:controller => "patients", :action => "document_list", :patientid => "1")
    expect(:get => "/patients/1/documents/2").to route_to(:controller => "patients", :action => "document", :patientid => "1", :documentid => "2")
    expect(:post => "/patients/1/documents").to route_to(:controller => "patients", :action => "new_document", :patientid => "1")
  end


  let(:valid_test_message) do
    {:valid => "true" }
  end

  let (:invalid_test_message) do
    {:valid => "false" }
  end

  it "GET /patients to return json list of patients" do
    allow(NciMatchPatientModels::Patient).to receive(:scan).and_return([patient_dbm, patient_dbm])

    get :patient_list, format: :json

    expect(response).to have_http_status(200)

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "GET /patients/1 to return json patient" do
    allow(NciMatchPatientModels::Patient).to receive(:scan).and_return(patient_dbm)

    get :patient, :patientid => "2222"

    expect(response).to have_http_status(200)

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "GET /patients/1 should handle errors by returning status 500" do
    allow(NciMatchPatientModels::Patient).to receive(:scan).and_raise("An Error")

    get :patient, :patientid => "2222"

    expect(response).to have_http_status(500)
    expect(response.body).to include "An Error"
  end

  it "GET /patients/1/timeline to return json patient timeline" do
    allow(NciMatchPatientModels::PatientEvent).to receive(:scan).and_return(patient_event_dbm)

    get :timeline, :patientid => "1", format: :json

    expect(response).to have_http_status(200)

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "GET  /patients/1/sampleHistory/2" do
    # .to route_to(:controller => "patients", :action => "sample", :patientid => "1", :sampleid => "2")
    get :sample, :patientid => "1", sampleid: "2"

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "POST /registration" do
    # route_to(:controller => "patients", :action => "registration")

    allow(Aws::Sqs::Publisher).to receive(:publish).and_return("")
    post :registration, valid_test_message.to_json

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "POST /specimenReceipt" do
    # route_to(:controller => "patients", :action => "specimen_receipt")
    allow(Aws::Sqs::Publisher).to receive(:publish).and_return("")
    post :specimen_receipt, valid_test_message.to_json

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "POST /assayOrder" do
    # route_to(:controller => "patients", :action => "assay_order")
    allow(Aws::Sqs::Publisher).to receive(:publish).and_return("")
    post :assay_order, valid_test_message.to_json

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "POST /assayResult" do
    # route_to(:controller => "patients", :action => "assay_result")
    allow(Aws::Sqs::Publisher).to receive(:publish).and_return("")
    post :assay_result, valid_test_message.to_json

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "POST /pathologyStatus" do
    # route_to(:controller => "patients", :action => "pathology_status")
    allow(Aws::Sqs::Publisher).to receive(:publish).and_return("")
    post :pathology_status, valid_test_message.to_json

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "POST /variantResult" do
    # route_to(:controller => "patients", :action => "variant_result")
    allow(Aws::Sqs::Publisher).to receive(:publish).and_return("")
    post :variant_result, valid_test_message.to_json

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "POST /patients/1/sampleFile" do
    # route_to(:controller => "patients", :action => "sample_file", :patientid => "1")
    allow(Aws::Sqs::Publisher).to receive(:publish).and_return("")
    post :sample_file, :patientid => "1"

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "PUT /patients/1/variantStatus" do
    # route_to(:controller => "patients", :action => "variant_status", :patientid => "1")
    put :variant_status, :patientid => "1"

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "PUT /patients/1/variantReportStatus" do
    # route_to(:controller => "patients", :action => "variant_report_status", :patientid => "1")
    put :variant_report_status, :patientid => "1"

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "POST /patients/1/assignmentConfirmation" do
    # route_to(:controller => "patients", :action => "assignment_confirmation", :patientid => "1")
    allow(Aws::Sqs::Publisher).to receive(:publish).and_return("")
    post :assignment_confirmation, :patientid => "1"

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "POST /patientStatus" do
    # route_to(:controller => "patients", :action => "patient_status")
    allow(Aws::Sqs::Publisher).to receive(:publish).and_return("")
    post :patient_status, valid_test_message.to_json

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "GET  /patients/1/documents" do
    # route_to(:controller => "patients", :action => "document_list", :patientid => "1")
    get :document_list, :patientid => "1"

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "GET  /patients/1/documents/2" do
    # route_to(:controller => "patients", :action => "document", :patientid => "1", :documentid => "2")
    get :document, :patientid => "1", documentid: "2"

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "POST /patients/1/documents" do
    # route_to(:controller => "patients", :action => "new_document", :patientid => "1")
    post :new_document, :patientid => "1"

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end


end
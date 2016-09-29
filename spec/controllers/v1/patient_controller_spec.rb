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

  let(:patient_event_dbm) do
    stub_model NciMatchPatientModels::Event,
               :patient_id => 'PAT123',
               :event_date => '2016-05-09T22:06:33+00:00',
               :event_name => 'Event Name 1',
               :event_type => 'Patient',
               :event_message => 'Message1',
               :event_data => {"status" => "Pending", "biopsy_sequence_number" => "B-987456"}
  end

  let(:specimen_dbm) do
    stub_model NciMatchPatientModels::Specimen,
               :patient_id => 'PAT123',
               :collected_date => '2016-05-09T22:06:33+00:00',
               :surgical_event_id => 'SUREVT1',
               :failed_date => '2016-05-09T22:06:33+00:00',
               :study_id => 'APEC1621',
               :type => 'Blood',
               :pathology_status => 'Exists',
               :pathology_status_date => '2016-05-09T22:06:33+00:00',
               :variant_report_confirmed_date => '2016-05-09T22:06:33+00:00',
               :active_molecular_id => 'ACTMOLID123',
               :assays => [],
               :assignments => [],
               :specimen_shipments => []
  end

  let(:variant_report_dbm) do
    stub_model NciMatchPatientModels::VariantReport,
      :surgical_event_id => 'SUREVT1',
      :variant_report_received_date => '2016-05-09T22:06:33+00:00',

      :patient_id => 'PAT123',
      :molecular_id => 'ACTMOLID123',
      :analysis_id => 'ANLS123',
      :status => 'PENDING',
      :status_date => '2016-05-09T22:06:33+00:00',

      :comment => 'Panding confirmation',

      :dna_bam_file_path => 'http://blah.com/file',
      :dna_bai_file_path => 'http://blah.com/file',
      :rna_bam_file_path => 'http://blah.com/file',
      :rna_bai_file_path => 'http://blah.com/file',
      :vcf_path => 'http://blah.com/file',

      :total_variants => 10,
      :cellularity => 4,
      :total_mois => 6,
      :total_amois => 2,
      :total_confirmed_mois => 4,
      :total_confirmed_amois => 2
  end

  let(:variant_dbm) do
    stub_model NciMatchPatientModels::Variant,

      :molecular_id_analysis_id        => 'MOLANLSID123',
      :variant_type                    => 'MSH1',

      :patient_id                      => 'PAT123',
      :surgical_event_id               => 'SUREVT1',
      :molecular_id                    => 'MOLDID',
      :analysis_id                     => 'ANLS123',

      :status                          => 'CONFIRNED',
      :status_date                     => '2016-05-09T22:06:33+00:00',
      :comment                         => 'Confrirmed'

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

  it "route correctly" do
    expect(:get => "api/v1/patients/1/variant_reports").to route_to(:controller => "v1/variant_reports", :action => "index",
                                                           :patient_id => "1")
    expect(:get => "api/v1/patients/1/assignments").to route_to(:controller => "v1/assignments", :action => "index",
                                                                       :patient_id => "1")
    expect(:get => "api/v1/patients/1/assignments/1234567").to route_to(:controller => "v1/assignments", :action => "show",
                                                                               :patient_id => "1", :id => "1234567")
  end


  let(:valid_test_message) do
    {:valid => "true"}
  end

  let (:invalid_test_message) do
    {:valid => "false"}
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
    allow(NciMatchPatientModels::Specimen).to receive(:scan).and_return([specimen_dbm])
    allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([variant_report_dbm])
    allow(NciMatchPatientModels::Variant).to receive(:scan).and_return([variant_dbm])
    allow(NciMatchPatientModels::Shipment).to receive(:scan).and_return([])

    get :show, :id => "2222"

    expect(response).to have_http_status(200)

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  # it "GET /patients/1 should handle errors by returning status 500" do
  #   allow(NciMatchPatientModels::Patient).to receive(:scan).and_raise("An Error")
  #
  #   get :show, :id => "2222"
  #
  #   expect(response).to have_http_status(500)
  #   expect(response.body).to include "message"
  # end

  let(:variant_status_message) do
    {
        "variant_uuid" => "e18e2bd6-b4e7-4375-99bd-c14df7d51f83",
        "confirmed" => "true",
        "comment" => "I here confirm this variant"
    }.to_json
  end
  let(:variant_status_response) do
    {
        "message" => "success"
    }.to_json
  end


  # it "PUT /patients/1/variantReportStatus" do
  #   # route_to(:controller => "patients", :action => "variant_report_status", :patientid => "1")
  #   put :variant_reports, :patient_id => "1", :molecular_id => "mid", :analysis_id => "aid"
  #
  #   expect {
  #     JSON.parse(response.body)
  #   }.to_not raise_error
  # end

  # it "POST /patients/1/assignmentConfirmation" do
  #   # route_to(:controller => "patients", :action => "assignment_confirmation", :patientid => "1")
  #   allow(Aws::Sqs::Publisher).to receive(:publish).and_return("")
  #   put :assignment_reports, :patient_id => "1", :date_assigned => "123456"
  #
  #   expect {
  #     JSON.parse(response.body)
  #   }.to_not raise_error
  # end

  # it "POST /patientStatus" do
  #   message_body = {"status" => "Success", "error" => "some error"}
  #   allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
  #   allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
  #   allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
  #   allow(HTTParty::Response).to receive(:body).and_return(message_body)
  #
  #   allow(Aws::Sqs::Publisher).to receive(:publish).and_return("")
  #   post :patient_status, valid_test_message.to_json
  #
  #   expect {
  #     JSON.parse(response.body)
  #   }.to_not raise_error
  # end

  # it "GET  /patients/1/documents" do
  #   # route_to(:controller => "patients", :action => "document_list", :patientid => "1")
  #   get :document_list, :patient_id => "1"
  #
  #   expect {
  #     JSON.parse(response.body)
  #   }.to_not raise_error
  # end

  # it "GET  /patients/1/documents/2" do
  #   # route_to(:controller => "patients", :action => "document", :patientid => "1", :documentid => "2")
  #   get :document, :patient_id => "1", document_id: "2"
  #
  #   expect {
  #     JSON.parse(response.body)
  #   }.to_not raise_error
  # end
  #
  # it "POST /patients/1/documents" do
  #   # route_to(:controller => "patients", :action => "new_document", :patientid => "1")
  #   post :new_document, :patient_id => "1"
  #
  #   expect {
  #     JSON.parse(response.body)
  #   }.to_not raise_error
  # end


end
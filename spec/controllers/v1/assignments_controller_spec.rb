require 'rails_helper'
require 'factory_girl_rails'
require 'aws-record'

describe V1::AssignmentsController do

  before(:each) do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Request).to receive(:perform).and_return(true)
  end


  it 'GET #index should return empty when nothing is found' do
    allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([])
    get :index
    expect(response.body).to eq("[]")
    expect(response).to have_http_status(200)
  end

  # it 'GET #show should return error message when empty' do
  #   expect( get :show, :id => "3366").to have_http_status(404)
  # end

  it 'GET #index should return correctly' do
    allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([{:patient => "3366" ,:surgical_event_id => "1111", :treatment_assignment_results => []}])
    allow(NciMatchPatientModels::Specimen).to receive(:scan).and_return([])
    get :index
    expect(response.body).not_to be_empty
    expect(response).to have_http_status(200)
  end

  it 'GET #show' do
    expect(:get => "api/v1/patients/assignments/1").to route_to(:controller => "v1/assignments", :action => "show", :id => "1")
  end
  it 'GET #index' do
    expect(:get => "api/v1/patients/assignments?analysis_id=job1&patient_id=3366").to route_to(:controller => "v1/assignments",
                                                                                               :action => "index",
                                                                                               :patient_id => "3366",
                                                                                               :analysis_id => "job1")
    expect(:get => "api/v1/patients/assignments").to route_to(:controller => "v1/assignments",
                                                                                               :action => "index")
  end

  it 'POST #create' do
    expect { post :create, :id => 1}.to raise_error(ActionController::UrlGenerationError)
  end

  it '#update should throw an route error' do
    expect { patch :update, :id => 1}.to raise_error(ActionController::UrlGenerationError)
  end

  it '#delete should route correctly' do
    expect(:delete => "api/v1/patients/assignments/1").to route_to(:controller => "v1/assignments", :action => "destroy", :id => "1")
  end

  it "#delete will add message to queue" do
    message_body = {"status" => "Success", "error" => "some error"}

    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:body).and_return(message_body)
    allow(JobBuilder).to receive(:new).and_return(true)
    expect(delete :destroy, :id => 1).to be_truthy
  end

  it "#delte will raise error" do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(500)
    expect(delete :destroy, :id => 1).to have_http_status(403)
  end

end
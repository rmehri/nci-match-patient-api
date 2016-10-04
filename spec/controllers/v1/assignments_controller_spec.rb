require 'rails_helper'
require 'factory_girl_rails'
require 'aws-record'

describe V1::AssignmentsController do

  before(:each) do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Request).to receive(:perform).and_return(true)
  end


  it 'should return an assignment report based on analysis id' do
    # assignment = NciMatchPatientModels::Assignment.new
    # specimen = NciMatchPatientModels::Specimen.new
    # specimen.assays = {}
    #
    # allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([assignment])
    #
    # get :show, :id => "2222"
    #
    # expect(response).to have_http_status(200)
    #
    # expect {
    #   JSON.parse(response.body)
    # }.to_not raise_error
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

  it '#delete should throw an route error' do
    expect { delete :destroy, :id => 1}.to raise_error(ActionController::UrlGenerationError)
  end

end
require 'rails_helper'
require 'factory_girl_rails'
require 'aws-record'

describe V1::AssignmentsController do

  before(:each) do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Request).to receive(:perform).and_return(true)
  end

  it 'should route correctly' do
    expect(:get => "api/v1/patient/patients/3366/assignments?analysis_id=job1").to route_to(:controller => "v1/assignments",
                                                                                              :action => "index",
                                                                                              :patient_id => "3366",
                                                                                              :analysis_id => "job1")
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

end
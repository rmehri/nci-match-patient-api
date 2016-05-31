require 'rails_helper'
require 'factory_girl_rails'

xdescribe PatientsController do

  # before(:each) do
  #   setup_knock()
  # end

  it "route to correct controller" do
    expect(:get => "/patients" ).to route_to(:controller => "patients", :action => "index")
    expect(:get => "/patients/1" ).to route_to(:controller => "patients", :action => "show", :id => "1")
    expect(:get => "/patients/1/timeline" ).to route_to(:controller => "patients", :action => "timeline", :id => "1")
  end

  it "GET /patients to return json list of patients" do
    get :index, format: :json

    expect(response).to have_http_status(200)

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "GET /patients/1 to return json patient" do
    get :show, :id => "1", format: :json

    expect(response).to have_http_status(200)

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

  it "GET /patients/1/timeline to return json patient timeline" do
    get :timeline, :id => "1", format: :json

    expect(response).to have_http_status(200)

    expect {
      JSON.parse(response.body)
    }.to_not raise_error
  end

end
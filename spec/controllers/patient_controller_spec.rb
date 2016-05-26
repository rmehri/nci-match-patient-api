require 'rails_helper'
require 'factory_girl_rails'

describe PatientsController do

  # before(:each) do
  #   setup_knock()
  # end

  it "route to correct controller" do
    expect(:get => "/patients" ).to route_to(:controller => "patients", :action => "index")
    expect(:get => "/patients/1" ).to route_to(:controller => "patients", :action => "show", :id => "1")
    expect(:get => "/patients/1/timeline" ).to route_to(:controller => "patients", :action => "timeline", :id => "1")
  end

  it "GET /patients to return json list of patients" do

  end

  it "GET /patients/1 to return json patient" do

  end

  it "GET /patients/1/timeline to return json patient timeline" do

  end

end
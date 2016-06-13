require 'rails_helper'

require 'nci_match_patient_models'
# require 'nci_match_patient_models/version'

describe VersionController do

  describe "GET #version" do

    it "should recongnize Models gem" do
      gem_v = NciMatchPatientModels::VERSION
      p NciMatchPatientModels::Patient.new
      expect(gem_v).to_not be nil
    end


    it "Should return the API version" do
     get :version
     expect(response.body).to eq(NciMatchPatientApi::Application.VERSION)
     expect(response).to have_http_status(200)
    end

    it "should route to the correct controller" do
      expect(:get => "/version" ).to route_to(:controller => "version", :action => "version")
    end

    it "should handle an error correctly" do
      allow(NciMatchPatientApi::Application).to receive(:VERSION).and_raise("this error")
      get :version
      expect(response).to have_http_status(500)
    end

  end
end
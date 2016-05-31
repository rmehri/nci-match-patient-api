require 'rails_helper'

xdescribe VersionController do

  describe "GET #version" do
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
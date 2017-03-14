require 'rails_helper'
require 'nci_match_patient_models'
require 'nci_match_patient_models'
# require 'nci_match_patient_models/version'

require 'aws-record/record'

describe V1::VersionsController do
  describe 'GET #version' do
    it 'should recongnize Models gem' do
      gem_v = NciMatchPatientModels::VERSION
      expect(gem_v).to_not be nil
    end

    # it 'Should return the API version' do
    #  get :version
    #  expect(response.body).to include(NciMatchPatientApi::Application.version)
    #  expect(response).to have_http_status(200)
    # end

    it 'should route to the correct controller' do
      expect(get: '/api/v1/patients/version').to route_to(controller: 'v1/versions', action: 'version')
    end

    it 'should handle an error correctly' do
      allow(NciMatchPatientApi::Application).to receive(:version).and_raise('this error')
      get :version
      expect(response).to have_http_status(500)
    end

    it {expect(get: '/api/v1/patients/version').to be_truthy}
  end
end
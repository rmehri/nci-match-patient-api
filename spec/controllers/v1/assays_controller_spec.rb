require 'rails_helper'
require 'factory_girl_rails'

describe V1::AssaysController do
  before(:each) do
    setup_knock
    @request.headers['Content-Type'] = 'application/json'
  end

  assay = FactoryGirl.build(:assay_message)

  describe 'GET #Assays' do
    it 'should route to the correct controller' do
      expect(get: 'api/v1/patients/assays').to route_to(controller: 'v1/assays', action: 'index')
    end

    it 'should return an empty array when there are no assays' do
      allow(NciMatchPatientModels::Specimen).to receive(:scan).and_return([])
      get :index
      expect(response.body).to eq('[]')
      expect(response).to have_http_status(200)
    end

    it 'should return the list of assays if there are any' do
      allow(NciMatchPatientModels::Specimen).to receive(:find_by).and_return([assay])
      get :index
      expect(response).to have_http_status(200)
      expect { JSON.parse(response.body) }.to_not raise_error
      expect(response).to_not be_nil
    end
  end
end

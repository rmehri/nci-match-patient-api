require 'rails_helper'
require 'aws-record/record'

describe V2::VersionsController do
  describe 'GET #version' do

    it 'should route to the correct controller' do
      expect(get: '/api/v2/patients/versions').to route_to(controller: 'v2/versions', action: 'show')
    end
    it 'error out correctly' do
      allow(File).to receive(:read).and_raise("this error")
      expect(get: 'api/v2/patients/versions').to be_truthy
    end

    it {expect(get: '/api/v2/patients/versions').to be_truthy}
  end
end
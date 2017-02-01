require 'rails_helper'

describe V1::ErrorsController do
  context 'on unrecognized URL' do
    it 'should route to the correct controller' do
      expect(get: 'api/v1/patients/1/2').to route_to(controller: 'v1/errors', action: 'bad_request',
                                                                  'path' => 'patients/1/2')
    end

    it 'should raise the UrlGenerationError' do
      expect { get :bad_request, patient_id: '3366' }.to raise_error(ActionController::UrlGenerationError)
    end
  end
end

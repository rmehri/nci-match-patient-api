require 'rails_helper'

RSpec.describe PatientProcessor do


  context 'reach out to patient processor' do

    let(:request) {ActionDispatch::TestRequest.create()}

    it 'fail gracefully' do
      expect{PatientProcessor.run_service("mock", "test_data", request.uuid, "token")}.to raise_error(URI::InvalidURIError)
    end

    it 'send a message successfully' do
      stub_request(:any, 'https://pedmatch-int.nci.nih.gov:3010/mock')
          .to_return(status: 201, body: 'whatever', headers: { some_kind_of: 'header' })
      expect(PatientProcessor.run_service("/mock", "test_data", "123", "token")).to be_truthy
    end
  end

end
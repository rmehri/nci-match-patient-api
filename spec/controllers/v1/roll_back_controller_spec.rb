require 'rails_helper'

RSpec.describe V1::RollBackController do

  let(:user) { {:roles => ["Admin"]} }
  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  context 'route to the correct controller' do

    it {expect(:put => "api/v1/patients/123//variant_report_rollback").to route_to(:controller => "v1/roll_back", :action => "rollback_variant_report",
                                                                           :patient_id => "123")}
    it {expect(:put => "api/v1/patients/123//assignment_report_rollback").to route_to(:controller => "v1/roll_back", :action => "rollback_assignment_report",
                                                                                   :patient_id => "123")}
  end


  context 'accept a valid request' do
    it 'process a valid rollback_variant_report' do
      allow(NciMatchPatientModelExtensions::PatientExtension).to receive(:roll_back_from_variant_report_action).and_return(true)
      put :rollback_variant_report, params: { :patient_id => "123" }
      expect(response).to have_http_status(200)
    end


    it 'process a valid rollback_assignment_report' do
      allow(NciMatchPatientModelExtensions::PatientExtension).to receive(:roll_back_from_assignment_report_action).and_return(true)
      put :rollback_assignment_report, params: { :patient_id => "456" }
      expect(response).to have_http_status(200)
    end
  end

  context 'rails a invalid request' do
    it 'process a invalid rollback_variant_report' do
      allow(NciMatchPatientModelExtensions::PatientExtension).to receive(:roll_back_from_variant_report_action).and_raise(NoMethodError)
      put :rollback_variant_report, params: { :patient_id => "123" }
      expect(response).to have_http_status(500)
    end

    it 'process a invalid rollback_assignment_report' do
      allow(NciMatchPatientModelExtensions::PatientExtension).to receive(:roll_back_from_assignment_report_action).and_raise(NoMethodError)
      put :rollback_variant_report, params: { :patient_id => "123" }
      expect(response).to have_http_status(500)
    end
  end

end
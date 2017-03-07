require 'rails_helper'

RSpec.describe V1::ShipmentStatusController, :type => :controller do

  context 'route GET #show' do
    it { expect(:get => "api/v1/patients/shipment_status/123").to route_to(:controller => "v1/shipment_status", :action => "show", :id => "123") }
  end

  context 'GET #show' do
    it 'handle exceptions' do
      get :show, params: {id: '123'}
      expect(response).to have_http_status(404)
    end

    it 'return data' do
      allow(NciMatchPatientModels::Shipment).to receive(:find_by).and_return([{patient_id: '123', destination: 'mocha',
                                                                               molecular_id: '123_mol_test'}])
      allow(NciMatchPatientModels::VariantReport).to receive(:query_by_patient_id).and_return([{molecular_id: '123_mol_test',
                                                                                               status: 'CONFIRMED',
                                                                                                analysis_id: '123_ana_test'}])
      get :show, params: {id: '123_mol_test'}
      expect(response.body).to be_truthy
      expect(JSON.parse(response.body)).to eq({"patient_id"=>"123", "molecular_id"=>"123_mol_test",
                                               "eligible_for_new_variant_report"=>false, "message"=>"Molecular_id [123_mol_test] already has a confirmed variant report",
                                               "analysis_ids"=>["123_ana_test"], "site"=>"mocha"})
    end
  end

end
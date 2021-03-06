require 'rails_helper'
require 'factory_girl_rails'
require 'aws-record'

describe V1::VariantReportsController do

  it 'GET #show' do
    expect(:get => "api/v1/patients/variant_reports/3366").to route_to( :controller => "v1/variant_reports",
                                                                        :action => "show",
                                                                        :id => "3366")
  end

  it 'GET #index' do
    expect(:get => "api/v1/patients/variant_reports?analysis_id=job1&patient_id=3366").to route_to(:controller => "v1/variant_reports",
                                                                                                   :action => "index",
                                                                                                   :patient_id => "3366",
                                                                                                   :analysis_id => "job1")
    expect(:get => "api/v1/patients/variant_reports").to route_to(:controller => "v1/variant_reports",
                                                                  :action => "index")
  end

  it 'GET #show no data found' do
    allow(NciMatchPatientModels::VariantReport).to receive(:query).and_return([])
    allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([])
    expect(get :show, params: {id: "3366"}).to have_http_status(404)
  end

  it 'GET #show with data' do
    allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([{:analysis_id => "1234"}])
    allow(NciMatchPatientModels::Variant).to receive(:scan).and_return([{}])
    allow(TreatmentArmApi).to receive(:get_treatment_arms).and_return([{}])
    allow(RuleEngine).to receive(:get_mois).and_return({}.to_json)
    allow(Convert::VariantReportDbModel).to receive(:to_ui_model).and_return([])
    get :show, params: {id: "12123"}
    expect(response).to have_http_status(200)
    expect(response.body).not_to be_empty
  end

  it 'POST #create' do
    expect { post :create, params: {id: 1}}.to raise_error(ActionController::UrlGenerationError)
  end

  it '#update should throw an route error' do
    expect { patch :update, params: {id: 1}}.to raise_error(ActionController::UrlGenerationError)
  end
end

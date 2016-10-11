require 'rails_helper'

describe V1::QcVariantReportsController do

  it 'GET #show' do
    expect(:get => "api/v1/patients/3366/qc_variant_reports/analysis123").to route_to(:controller => "v1/qc_variant_reports",
                                                                       :action => "show",
                                                                                      :patient_id => "3366",
                                                                                      :id => "analysis123")
  end

  it 'GET #show 404 error' do
    expect(get :show, :patient_id => "3366", :id => "1" ).to have_http_status(404)
  end

  it 'GET #show 404 error' do
    allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([{:rndom => "random"}])
    allow(Aws::S3::S3Reader).to receive(:read).and_return("BLAH BLAH")
    expect( get :show, :patient_id => "3366", :id => "1").to have_http_status(500)
  end

  it 'GET #show correctly' do
    allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([{:tsv_file_name => "random"}])
    allow(Aws::S3::S3Reader).to receive(:read).and_return("BLAH BLAH")
    expect( get :show, :patient_id => "3366", :id => "1").to have_http_status(200)
  end

  it 'should not route' do
    expect { get :index, :patient_id => "3366", :id => "1"}.to raise_error(ActionController::UrlGenerationError)
  end
end
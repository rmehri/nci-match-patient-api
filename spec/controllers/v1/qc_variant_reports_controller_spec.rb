require 'rails_helper'

describe V1::QcVariantReportsController do

  it 'GET #show' do
    expect(:get => "api/v1/patients/3366/qc_variant_reports/analysis123").to route_to(:controller => "v1/qc_variant_reports",
                                                                       :action => "show",
                                                                                      :patient_id => "3366",
                                                                                      :id => "analysis123")
  end

  it 'GET #show 404 error' do
    expect(get :show, :patient_id => "123", :id => "1" ).to have_http_status(404)
  end

  it 'GET #show 200 code' do
    variant_report = NciMatchPatientModels::VariantReport.new
    variant_report.patient_id = "3366"
    variant_report.variant_report_received_date = "2016-09-12"
    variant_report.analysis_id = "1"
    variant_report.molecular_id = "2"
    variant_report.tsv_file_name = "test.tsv"

    allow(NciMatchPatientModels::VariantReport).to receive(:query).and_return([variant_report])
    allow(Aws::S3::S3Reader).to receive(:read).and_return({:patient_id => "3366"})
    expect( get :show, :patient_id => "3366", :id => "1").to have_http_status(200)
  end

  it 'GET #show correctly' do
    variant_report = NciMatchPatientModels::VariantReport.new
    variant_report.patient_id = "3366"
    variant_report.variant_report_received_date = "2016-09-12"
    variant_report.analysis_id = "1"
    variant_report.molecular_id = "2"
    variant_report.ion_reporter_id = "3"
    variant_report.tsv_file_name = "4.tsv"

    allow(NciMatchPatientModels::VariantReport).to receive(:query).and_return([variant_report])
    allow(Aws::S3::S3Reader).to receive(:read).and_return({:patient_id => "3366"})
    expect( get :show, :patient_id => "3366", :id => "1").to have_http_status(200)
  end

  it 'should not route' do
    expect { get :index, :patient_id => "3366", :id => "1"}.to raise_error(ActionController::UrlGenerationError)
  end
end
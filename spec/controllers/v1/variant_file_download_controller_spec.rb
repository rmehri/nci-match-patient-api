require 'rails_helper'


RSpec.describe V1::VariantFileDownloadController, type: :controller do

  it 'route GET #show' do
    expect(:get => "api/v1/patients/123/variant_file_download/1").to route_to(:controller => "v1/variant_file_download", :action => "show", :patient_id => '123', :id => '1')
  end


  it 'return data correctly' do
    allow(NciMatchPatientModels::VariantReport).to receive(:query_by_analysis_id).and_return({:variant => 'data'})
    allow(Aws::S3::S3Reader).to receive(:get_presigned_url).and_return("https://url/faker")
    get :show, params: {:file => 'file_name', :patient_id => '123_test', :id => 'abc'}
    expect(response.body).to be_truthy
    expect(response).to have_http_status(200)
  end

  it 'fail gracefully' do
    allow(NciMatchPatientModels::VariantReport).to receive(:query_by_analysis_id).and_return({})
    get :show, params: {:file => 'file_name', :patient_id => '123_test', :id => 'abc'}
    expect(response).to have_http_status(404)
  end


  it 'return blank when nothing is found' do
    allow(NciMatchPatientModels::VariantReport).to receive(:query_by_analysis_id).and_return({})
    allow(Aws::S3::S3Reader).to receive(:get_presigned_url).and_return("https://url/faker")
    get :show, params: {:file => 'file_name', :patient_id => '123_test', :id => 'abc'}
    expect(response.body).to eq("")
  end

end
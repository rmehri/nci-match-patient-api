require 'rails_helper'


RSpec.describe V1::S3Controller, type: :controller do

  context 'route to the correct controller' do
    it{expect(:post => 'api/v1/patients/test/s3').to route_to(:controller => 'v1/s3', :action => 'create', :patient_id => 'test')}
    it{expect(:get => 'api/v1/patients/test/s3').to route_to(:controller => 'v1/s3', :action => 'index', :patient_id => 'test')}
    it{expect(:get => 'api/v1/patients/test/s3/file').to route_to(:controller => 'v1/s3', :action => 'show', :patient_id => 'test', :id => 'file')}
  end


  # context 'create a s3 presigned link' do
  #   it 'will create the link' do
  #     s3_client = instance_double(Aws::S3::Client)
  #     allow(Aws::S3::Client).to receive(:new).and_return(s3_client)
  #     allow(Aws::S3::Presigner.new).to receive(:presigned_url).and_return('')
  #     post :create, :file_name => 'Test.txt'
  #     p response.body
  #   end
  # end

end
require 'rails_helper'

describe V1::HealthChecksController do
  describe 'GET #HealthCheck' do
    s3_bucket = Rails.configuration.environment.fetch('s3_bucket')
    s3_url = Rails.configuration.environment.fetch('s3_url')

    it 'should route to the correct controller' do
      expect(get: 'api/v1/patients/healthcheck').to route_to(controller: 'v1/health_checks', action: 'health_check')
    end

    it 'Should return the Connection Details' do
      get :health_check
      expect(response).to have_http_status(200)
      expect(response.body).to eq({ 'dynamodb_connection' => 'successful', 'queue_name' => 'patient_queue', 'queue_connection' => 'successful',
                                    's3_bucket_name' => s3_bucket, 's3_url' => s3_url, 's3_connection' => 'successful' }.to_json)
    end

    it 'should handle errors properly' do
      db_client = instance_double(Aws::DynamoDB::Client)
      allow(Aws::DynamoDB::Client).to receive(:new).and_return(db_client)
      allow(db_client).to receive(:list_tables).and_return(nil)
      get :health_check
      expect(response.body).to eq({ 'dynamodb_connection' => nil, 'queue_name' => 'patient_queue', 'queue_connection' => 'successful',
                                    's3_bucket_name' => s3_bucket, 's3_url' => s3_url, 's3_connection' => 'successful' }.to_json)
   end
  end
end

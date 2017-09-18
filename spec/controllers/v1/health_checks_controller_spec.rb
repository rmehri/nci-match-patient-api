require 'rails_helper'

describe V1::HealthChecksController do
  describe 'GET #HealthCheck' do
    s3_bucket = Rails.configuration.environment.fetch('s3_bucket')
    s3_url = Rails.configuration.environment.fetch('s3_url')
    it 'should route to the correct controller' do
      expect(get: 'api/v1/patients/healthcheck').to route_to(controller: 'v1/health_checks', action: 'health_check')
    end

    it 'Should return the Connection Details' do
      allow(db_client).to receive(:list_tables).and_return([:table_name])
      allow(sqs_client).to receive(:get_queue_url).and_return(true)

      get :health_check
      expect(response).to have_http_status(200)
      expect(response.body).to eq({ 'dynamodb_connection' => 'successful', 'queue_name' => 'patient_queue', 'queue_connection' => 'successful',
                                    's3_bucket_name' => s3_bucket, 's3_url' => s3_url, 's3_connection' => 'successful' }.to_json)
    end

    it 'Should handle errors properly' do
      allow(db_client).to receive(:list_tables).and_return(nil)
      allow(sqs_client).to receive(:get_queue_url).and_return(true)

      get :health_check
      expect(response).to have_http_status(200)
      expect(response.body).to eq({ 'dynamodb_connection' => nil, 'queue_name' => 'patient_queue', 'queue_connection' => 'successful',
                                    's3_bucket_name' => s3_bucket, 's3_url' => s3_url, 's3_connection' => 'successful' }.to_json)
   end
 end
end

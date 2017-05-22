
module V1
  class HealthChecksController < ApplicationController
    def health_check
      result = {}
      result['dynamodb_connection'] = dynamodb_connection
      result['queue_name'] = Rails.configuration.environment.fetch('queue_name')
      result['queue_connection'] = queue_connection
      render json: result
    end

    private

    attr_reader :dynamodb_connection, :queue_connection

    def dynamodb_connection
      begin
        dynamodb = Aws::DynamoDB::Client.new(retry_limit: 1)
        'successfull' if dynamodb.list_tables.present?
      rescue => _error
        'unsuccessfull'
      end
    end

    def queue_connection
      begin
        region = Rails.configuration.environment.fetch('aws_region')
        end_point = "https://sqs.#{region}.amazonaws.com"
        access_key = Rails.application.secrets.aws_access_key_id
        aws_secret_access_key = Rails.application.secrets.aws_secret_access_key
        creds = Aws::Credentials.new(access_key, aws_secret_access_key)
        client = Aws::SQS::Client.new(endpoint: end_point, region: region, credentials: creds)
        'successfull' if client.get_queue_url(queue_name: Rails.configuration.environment.fetch('queue_name')).present?
      rescue => _error
        'unsuccessfull'
      end
    end
  end
end


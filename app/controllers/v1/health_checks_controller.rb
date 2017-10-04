
module V1
  class HealthChecksController < ApplicationController
    def health_check
      result = {}
      result['dynamodb_connection'] = dynamodb_connection
      result['queue_name'] = Rails.configuration.environment.fetch('queue_name')
      result['queue_connection'] = queue_connection
      result['s3_bucket_name'] = Rails.configuration.environment.fetch('s3_bucket')
      result['s3_url'] = Rails.configuration.environment.fetch('s3_url')
      result['s3_connection'] = s3_connection
      render json: result
    end

    private

    attr_reader :dynamodb_connection, :queue_connection, :s3_connection

    def dynamodb_connection
      begin
        dynamodb = Aws::DynamoDB::Client.new(retry_limit: 1)
        'successful' if dynamodb.list_tables.present?
      rescue => _error
        'unsuccessful'
      end
    end

    def queue_connection
      begin
        region = Rails.configuration.environment.fetch('aws_region')
        end_point = "https://sqs.#{region}.amazonaws.com"
        client = Aws::SQS::Client.new(endpoint: end_point, region: region)
        'successful' if client.get_queue_url(queue_name: Rails.configuration.environment.fetch('queue_name')).present?
      rescue => _error
        'unsuccessful'
      end
    end

    def s3_connection
      begin
        bucket_name = Rails.configuration.environment.fetch('s3_bucket')
        'successful' if Aws::S3::S3Reader.s3_client.bucket(bucket_name).present?
      rescue => _error
        'unsuccessful'
      end
    end
  end
end

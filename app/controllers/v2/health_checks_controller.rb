
module V2
  class HealthChecksController < ApplicationController

    def show
      result = {}
      result[:dynamodb_connected] = dynamodb_connection
      result[:queue_name] = Rails.configuration.environment.fetch('queue_name')
      result[:queue_connected] = queue_connection
      render json: result
    end


    private
    attr_reader :dynamodb_connection, :queue_connection

    def dynamodb_connection
      Aws::DynamoDB::Client.new.list_tables.present?
    end

    def queue_connection
      begin
        Shoryuken.sqs_client.get_queue_url(queue_name: Rails.configuration.environment.fetch('queue_name')).present?
      rescue Aws::SQS::Errors::NonExistentQueue => error
        return false
      end
    end
  end
end

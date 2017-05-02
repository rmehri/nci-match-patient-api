module Aws
  module Sqs
    class Publisher

      attr_accessor :client, :url

      def self.publish(message, uuid, passed_queue_name = Rails.configuration.environment.fetch('queue_name'))
        # JobBuilder.new("MessageJob").job.perform_later(message)
        begin
          @url = self.client.get_queue_url(queue_name: passed_queue_name).queue_url
          @client.send_message({queue_url: @url, :message_body => message.to_json,
                                :message_attributes =>
                                    {"X-Request-Id" => {string_value: uuid, data_type: "String"}}})
        rescue Aws::SQS::Errors::ServiceError => error
          p error
        end
      end


      def self.client
        @client ||= Aws::SQS::Client.new(endpoint: "https://sqs.#{Aws.config[:region]}.amazonaws.com",
                                         credentials: Aws::Credentials.new(Aws.config[:access_key_id], Aws.config[:secret_access_key]))
      end
    end
  end
end
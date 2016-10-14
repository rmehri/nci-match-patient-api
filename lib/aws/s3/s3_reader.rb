module Aws
  module S3
    class S3Reader
      attr_accessor :s3_client

      def self.read(bucket_name, path_to_file)

        resource = self.s3_client.bucket(bucket_name).object(path_to_file)
        raise "Specified resource path or name does not exist" if !resource.exists?

        resource.get({}).body.read
      end

      def self.download(bucket_name, path_to_file)

      end

      def self.s3_client
        @s3_client ||= Aws::S3::Resource.new(endpoint: "https://s3.amazonaws.com",
                                             region: Aws.config[:region],
                                             access_key_id: Aws.config[:access_key_id],
                                             secret_access_key: Aws.config[:secret_access_key]
        )
      end
    end
  end
end
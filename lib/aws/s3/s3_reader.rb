module Aws
  module S3
    class S3Reader
      attr_accessor :s3_client

      def self.read(bucket_name, path_to_file)

        resource = self.s3_client.bucket(bucket_name).object(path_to_file)
        raise "Specified resource path or name does not exist" if !resource.exists?

        resource.get({}).body.read
      end

      def self.get_presigned_url(bucket_name, path_to_file)

        resource = self.s3_client.bucket(bucket_name).object(path_to_file)
        raise "Specified resource path or name does not exist" if !resource.exists?

        resource.presigned_url(:get, expires_in: 20.minutes)
      end

      def self.get_file_set(bucket_name, path_to_file)
        object_summaries = self.s3_client.bucket(bucket_name).objects(prefix: path_to_file)
        file_set = []
        object_summaries.each do | object_summary |
          file_set.push({:file_path_name => object_summary.key,
                         :public_url => object_summary.public_url({}),
                         :file_size => object_summary.size,
                         :last_modified => object_summary.last_modified})

        end

        file_set
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
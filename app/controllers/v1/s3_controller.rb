module V1
  class S3Controller < ApplicationController
    before_action :authenticate_user
    before_action :s3_params, only: [:create, :show]

    def show
      render Aws::S3::Presigner.new(client: s3_client).presigned_url(:get_object,
                                                              bucket: Rails.configuration.environment.fetch('s3_bucket'),
                                                              key: "#{params[:patient_id]}/#{params[:file_name]}")
    end

    def index
      bucket = Aws::S3::Bucket.new(client: s3_client, name: Rails.configuration.environment.fetch('s3_bucket'))
      list = bucket.objects(prefix: "#{params[:patient_id]}/").collect do | obj |
        {
            name: obj.key,
            url: obj.presigned_url(:get, response_content_disposition: 'attachment'),
            comment: "",
            uploaded_date: obj.last_modified,
            user: obj.object.metadata["user"]
        }
      end
      render json: list
    end

    def create
      url = Aws::S3::Presigner.new(client: s3_client).presigned_url(:put_object,
                                                                    bucket: Rails.configuration.environment.fetch('s3_bucket'),
                                                                    key: "#{params[:patient_id]}/#{params[:file_name]}",
                                                                    acl: 'public-read-write', metadata: {'user' => current_user[:email].split('@')[0]})
      render json: {:presigned_url => url}
    end

    private

    def s3_client
      Aws::S3::Client.new(endpoint: Rails.configuration.environment.fetch('s3_url'))
    end

    def s3_params
      params.require(:file_name)
    end

  end
end
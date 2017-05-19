module V1
  class S3Controller < ApplicationController
    before_action :authenticate_user
    before_action :s3_params, only: :create

    def create
      client = Aws::S3::Client.new(endpoint: Rails.configuration.environment.fetch('s3_url'))
      url = Aws::S3::Presigner.new(client: client).presigned_url(:put_object, bucket: Rails.configuration.environment.fetch('s3_bucket'), key: params[:file_name])
      render json: {:presigned_url => url}
    end

    def s3_params
      params.require(:file_name)
    end

  end
end
module V1
  class S3Controller < ApplicationController
    before_action :authenticate_user
    before_action :s3_params, only: :create

    def create
      client = Aws::S3::Client.new(endpoint: Rails.configuration.environment.fetch('s3_url'))
      url = Aws::S3::Presigner.new(client: client).presigned_url(:put_object, bucket: Rails.configuration.environment.fetch('s3_bucket'), key: params[:file_name])
      uri = URI(url)
      headers = URI::decode_www_form(uri.query).to_h
      render json: {:presigned_url => url, host: "#{uri.scheme}://#{uri.host}", path: uri.path, :headers => headers}
    end

    def s3_params
      params.require(:file_name)
    end

  end
end
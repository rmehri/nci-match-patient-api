module V1
  class S3Controller < ApplicationController
    before_action :authenticate_user
    before_action :s3_params, only: [:create, :show]

    def show

    end

    def index
      bucket = Aws::S3::Bucket.new(client: s3_client, name: Rails.configuration.environment.fetch('s3_bucket'))
      list = bucket.objects(prefix: "#{params[:patient_id]}/").collect{ | obj | {name: obj.key, comment: "", uploaded_date: "", user: ""} }
      render json: list
    end

    def create
      # client = Aws::S3::Client.new(endpoint: Rails.configuration.environment.fetch('s3_url'))
      url = Aws::S3::Presigner.new(client: s3_client).presigned_url(:put_object, bucket: Rails.configuration.environment.fetch('s3_bucket'), key: "#{params[:patient_id]}/#{params[:file_name]}")
      uri = URI(url)
      headers = URI::decode_www_form(uri.query).to_h
      render json: {:presigned_url => url, host: "#{uri.scheme}://#{uri.host}", path: uri.path, :headers => headers}
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
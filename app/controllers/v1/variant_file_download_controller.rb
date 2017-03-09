module V1
  class VariantFileDownloadController < BaseController
    before_action :set_resource, only: [:show]

    def show
        file_key = params[:file]
        puts "=========== download file name: #{file_key}"
        variant_report = get_resource
        raise Errors::ResourceNotFound if variant_report.blank?

        url = Aws::S3::S3Reader.get_presigned_url(Rails.configuration.environment.fetch('s3_bucket'), file_key)
        render json: {:url => url}.to_json
    end

    private

    def set_resource(resource = {})
      resource = NciMatchPatientModels::VariantReport.query_by_analysis_id(params[:patient_id], params[:id])
      instance_variable_set("@#{resource_name}", resource)
    end
  end
end

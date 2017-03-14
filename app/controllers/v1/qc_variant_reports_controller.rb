
module V1
  class QcVariantReportsController < BaseController
    before_action :set_resource, only: [:show]

    def show
      variant_report = get_resource.compact
      s3_path = get_s3_file_path(variant_report)
      render json: Aws::S3::S3Reader.read(Rails.configuration.environment.fetch('s3_bucket'), s3_path)
    end

    private

    def get_s3_file_path(variant_report)
      qc_file = variant_report[:tsv_file_name].blank? ? "" : File.basename(variant_report[:tsv_file_name], ".tsv") + ".json"
      "#{variant_report[:ion_reporter_id]}/#{variant_report[:molecular_id]}/#{variant_report[:analysis_id]}/#{qc_file}"
    end

    def set_resource(resource = {})
      resource = NciMatchPatientModels::VariantReport.query_by_analysis_id(params[:patient_id], params[:id]).to_h
      raise Errors::ResourceNotFound if resource.blank?
      instance_variable_set("@#{resource_name}", resource)
    end

  end
end

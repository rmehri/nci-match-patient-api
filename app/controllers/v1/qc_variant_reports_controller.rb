
module V1
  class QcVariantReportsController < BaseController
    before_action :set_resource, only: [:show]

    def show
      begin

        variant_report = get_resource
        return standard_error_message("Resource not found", 404) if variant_report.blank?

        render json: Aws::S3::S3Reader.read(Rails.configuration.environment.fetch('s3_bucket'),
                                            get_s3_file_path(variant_report.to_h.compact))

      rescue => error
        standard_error_message(error.message)
      end
    end

    private

    def get_s3_file_path(variant_report)
      qc_file = File.basename(variant_report[:tsv_file_name], ".tsv") + ".json"
      "#{variant_report[:ion_reporter_id]}/#{variant_report[:molecular_id]}/#{variant_report[:analysis_id]}/#{qc_file}"
    end

    def set_resource(resource = {})

      resource = NciMatchPatientModels::VariantReport.query_by_analysis_id(params[:patient_id], params[:id])
      instance_variable_set("@#{resource_name}", resource)
    end

  end
end

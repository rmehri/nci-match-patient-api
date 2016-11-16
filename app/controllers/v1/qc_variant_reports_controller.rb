
module V1
  class QcVariantReportsController < BaseController
    before_action :set_resource, only: [:show]

    def show
      begin
        variant_report = get_resource
        render json: Aws::S3::S3Reader.read(Rails.configuration.environment.fetch('s3_bucket'),
                                            get_s3_file_path(variant_report))
      rescue => error
        standard_error_message(error)
        raise NameError
      end
    end

    private

    def get_s3_file_path(variant_report)
      begin
        qc_file = File.basename(variant_report[:tsv_file_name], ".tsv") + ".json"
        "#{variant_report[:ion_reporter_id]}/#{variant_report[:molecular_id]}/#{variant_report[:analysis_id]}/#{qc_file}"
      rescue => error
        standard_error_message(error.message)
      end
    end

    def set_resource(resource = {})
      resource = NciMatchPatientModels::VariantReport.query_by_analysis_id(params[:patient_id], params[:id]).to_h.compact
      instance_variable_set("@#{resource_name}", resource)
    end

  end
end

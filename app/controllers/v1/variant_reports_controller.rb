module V1
  class VariantReportsController < BaseController
    before_action :set_resource, only: [:show]
    # include Knock::Authenticable

    def show
      variant_report = get_resource.first.to_h
      cnvs = variant_report[:copy_number_variant_genes] || []
      cnvs.each do | cnv |
       new_vals = [ ]
       cnv['values'].each do | val |
         new_vals << val.to_f
       end
       cnv['values'] = new_vals
     end

      # variants = get_variants(variant_report[:analysis_id])

      # amois = get_amois(variant_report)
      # variant_report = Convert::VariantReportDbModel.to_ui_model(variant_report, variants, amois)
      render json: variant_report.compact
    end

    private
    def set_resource(resource = {})
      resources = NciMatchPatientModels::VariantReport.scan(resource_params).collect { |data| data.to_h }
      raise Errors::ResourceNotFound if resources.blank?
      instance_variable_set("@#{resource_name}", resources)
    end

    def get_variants(analysis_id)
      NciMatchPatientModels::Variant.scan(build_index_query({:analysis_id => analysis_id})).collect { |data| data.to_h.compact }
    end

    def get_amois(variant_report)
      puts "========== in get_amois: #{token}"
      VariantReportUpdater.new.updated_variant_report(variant_report, token)
    end

    def variant_reports_params
      params.require(:id)
      params[:analysis_id] = params.delete(:id)
      build_index_query(params.except(:action, :controller))
    end

  end
end

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
      render json: variant_report.compact
    end

    def index
      plural_resource_name = "@#{resource_name.pluralize}"
      resources = resource_class.scan(query_params).collect { |data| data.to_h }
      resources = resources.select {| resource| resource[:status] != "UNDETERMINED"}
      instance_variable_set(plural_resource_name, resources)
      render json: instance_variable_get(plural_resource_name)
    end

    def destroy
      is_valid = HTTParty.get("#{Rails.configuration.environment.fetch('patient_state_api')}/roll_back/variant_report/#{params[:id]}",
                              {:headers => {'X-Request-Id' => request.uuid, 'Authorization' => "Bearer #{token}"}})
      raise Errors::RequestForbidden, "Incoming message failed patient state validation: #{is_valid}" if is_valid.code.to_i > 200
      JobBuilder.new("RollBack::VariantReportJob").job.perform_later({:patient_id => params[:id]})
    end

    private
    def set_resource(_resource = {})
      resources = NciMatchPatientModels::VariantReport.scan(resource_params).collect { |data| data.to_h }
      raise Errors::ResourceNotFound if resources.blank?

      resources = resources.select {| resource| resource[:status] != "UNDETERMINED"}
      instance_variable_set("@#{resource_name}", resources)
    end

    def variant_reports_params
      params.require(:id)
      params[:analysis_id] = params.delete(:id)
      build_index_query(params.except(:action, :controller))
    end

  end
end

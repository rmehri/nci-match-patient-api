module V1
  class ActionItemsController < BaseController
    before_action :set_resource, only: [:index]

    def index
      render json: instance_variable_get("@#{resource_name}")
    end


    private
    def set_resource(resources = {})
      resources = NciMatchPatientModels::VariantReport.scan(resource_params).collect{ |record| build_model(record.to_h.compact) }
      resources += NciMatchPatientModels::Assignment.scan(resource_params).collect{ | record | build_model(record.to_h.compact) }
      instance_variable_set("@#{resource_name}", resources)
    end


    def action_items_params
      build_query({:patient_id => params.require(:patient_id), :status => 'PENDING'})
    end

    def build_model(record, type = 'variant_report')
      {
          :action_type => "PENDING_#{record[:variant_report_type].upcase}_#{type.upcase}",
          :molecular_id => record[:molecular_id],
          :analysis_id => record[:analysis_id],
          :created_date => record[:status_date]
      }
    end

  end
end
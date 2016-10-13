module V1
  class ActionItemsController < BaseController
    before_action :set_resource, only: [:index]

    def index
      render json: instance_variable_get("@#{resource_name}")
    end


    private
    def set_resource(resource = {})
      resources = NciMatchPatientModels::VariantReport.scan(resource_params).collect{ |record| record.to_h.compact }
      instance_variable_set("@#{resource_name}", resources)
    end


    def action_items_params
      build_query({:patient_id => params.require(:patient_id), :status => 'PENDING'})
    end

  end
end
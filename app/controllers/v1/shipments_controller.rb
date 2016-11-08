module V1
  class ShipmentsController < BaseController

    def show
      begin
        if get_resource.blank?
          standard_error_message("Resource not found", 404)
        else
          render json: get_resource.first
        end
      rescue Aws::DynamoDB::Errors::ServiceError => error
        standard_error_message(error.message)
      end
    end
    private

    def set_resource(resource = nil)
      resource ||= resource_class.scan(resource_params).collect{|data| data.to_h.compact }
      instance_variable_set("@#{resource_name}", resource)
    end

    def shipments_params
      # build_query({:molecular_id => params.require(:id)})
      params.require(:id)
      params[:molecular_id] = params.delete(:id)
      build_index_query(params.except(:action, :controller))
    end

  end
end
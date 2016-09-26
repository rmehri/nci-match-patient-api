module V2
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :set_resource, only: [:destroy, :show, :update]
    respond_to :json

    def create
      set_resource(resource_class.new(resource_params))
      if get_resource.save
        render :show, status: :created
      else
        render json: get_resource.errors, status: :unprocessable_entity
      end
    end

    #place holder
    def destroy

    end

    def index
      plural_resource_name = "@#{resource_name.pluralize}"
      resources = resource_class.scan(query_params).collect { |data| data.to_h.compact }
      instance_variable_set(plural_resource_name, resources)
      render json: instance_variable_get(plural_resource_name)
    end

    def show
      render json: get_resource
    end

    def update
      if get_resource.update(resource_params)
        render :show
      else
        render json: get_resource.errors, status: :unprocessable_entity
      end
    end


    private
    # @return [Object]
    def get_resource
      instance_variable_get("@#{resource_name}")
    end

    # Returns the allowed parameters for searching
    # Override this method in each API controller
    # to permit additional parameters to search on
    # @return [Hash]
    def query_params
      {}
    end

    # @return [Class]
    def resource_class
      @resource_class ||= "NciMatchPatientModels::#{resource_name.classify}".constantize
    end

    # @return [String]
    def resource_name
      @resource_name ||= self.controller_name
    end

    # Only allow a trusted parameter "white list" through.
    def resource_params
      @resource_params ||= self.send("#{resource_name}_params")
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_resource(resource = nil)
      resource ||= resource_class.scan({}).collect { |data| data.to_h.compact }
      instance_variable_set("@#{resource_name}", resource)
    end

    def build_query(params)
      {
          table_name: @resource_name,
          :attributes_to_get => build_attributes_to_get(params),
          :scan_filter => build_scan_filter(params.except("projections"))
      }
    end

    def build_attributes_to_get(params)
      if params.key?("projections")
        return params["projections"].split(",")
      end
    end

    def build_scan_filter(params)
      query = {}
      params.each do |key , value|
        query.merge!(key => {:comparison_operator => "EQ", :attribute_value_list => [value]})
      end
      query
    end

  end
end
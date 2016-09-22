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
      resources = resource_class.scan(query_params).collect { |data| data.to_h }
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
    # Returns the resource from the created instance variable
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

    # The resource class based on the controller
    # @return [Class]
    def resource_class
      @resource_class ||= "NciMatchPatientModels::#{resource_name.classify}".constantize
    end

    # The singular name for the resource class based on the controller
    # @return [String]
    def resource_name
      @resource_name ||= self.controller_name.singularize
    end

    # Only allow a trusted parameter "white list" through.
    # If a single resource is loaded for #create or #update,
    # then the controller for the resource must implement
    # the method "#{resource_name}_params" to limit permitted
    # parameters for the individual model.
    def resource_params
      @resource_params ||= self.send("#{resource_name}_params")
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_resource(resource = nil)
      resource ||= resource_class.scan({}).collect { |data| data.to_h }
      instance_variable_set("@#{resource_name}", resource)
    end

  end
end
module V1
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :set_resource, only: [:destroy, :show, :update]
    respond_to :json

    def create
      begin
        json_data = JSON.parse(request.raw_post)
        AppLogger.log(self.class.name, "Patient Api received message: #{json_data.to_json}")
        message = json_data.deep_transform_keys!(&:underscore).symbolize_keys
        type = MessageValidator.get_message_type(message)
        raise "Incoming message has UNKNOWN message type" if (type == 'UNKNOWN')

        error = MessageValidator.validate_json_message(type, message)
        raise "Incoming message failed message schema validation: #{error}" if !error.nil?

        if (type == 'VariantReport')
          shipments = NciMatchPatientModels::Shipment.find_by({"molecular_id" => message[:molecular_id]})
          raise "Unable to find shipment with molecular id [#{message[:molecular_id]}]" if shipments.length == 0

          patient_id = shipments[0].patient_id
          message[:patient_id] = patient_id
          p "============ patient added: #{message}"
        end

        status = validate_patient_state_and_queue(message, type)

        raise "Incoming message failed patient state validation" if (status == false)

        standard_success_message("Message has been processed successfully")
      rescue => error
        standard_error_message(error.message)
      end
    end

    def index
      begin
        plural_resource_name = "@#{resource_name.pluralize}"
        resources = resource_class.scan(query_params).collect { |data| data.to_h.compact }
        instance_variable_set(plural_resource_name, resources)
        render json: instance_variable_get(plural_resource_name)
      rescue => error
        standard_error_message(error.message)
      end
    end

    def show
      begin
        render json: get_resource
      rescue => error
        standard_error_message(error.message)
      end
    end

    #place holder
    def destroy
      render json: nil, status: 200
    end

    #place holder
    def update
      render json: nil, status: 200
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
      build_query(params.permit!.except(:controller, :action))
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
      begin
        resource ||= resource_class.scan(resource_params).collect { |data| data.to_h.compact }
        instance_variable_set("@#{resource_name}", resource)
      rescue => error
        standard_error_message(error.message)
      end
    end

    def build_query(params)
      {
          table_name: @resource_name,
          :attributes_to_get => build_attributes_to_get(params),
          :scan_filter => build_scan_filter(params.except(:projections, :projection))
      }
    end

    def build_attributes_to_get(params)
      if params.key?(:projections)
        return YAML.load(params[:projections])
      elsif params.key?(:projection)
        return params[:projection]
      end
    end

    def build_scan_filter(params)
      query = {}
      if params.key?(:attribute)
        params[:attribute].each do |value|
          query.merge!(value => {:comparison_operator => "NOT_NULL"})
        end
        params.delete(:attribute)
      end
      params.each do |key , value|
        query.merge!(key => {:comparison_operator => "EQ", :attribute_value_list => [value]})
      end
      query
    end

  end
end
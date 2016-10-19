module V1
  class SpecimenEventsController < BaseController
    before_action :set_resource, only: [:index]

    #Combination of Specimen with Shipments, Events, Variant_reports
    def index
      render json: instance_variable_get("@#{resource_name}")
    end

    private
    def set_resource(resource = {})
      resources = NciMatchPatientModels::Specimen.scan(resource_params).collect { |data| data.to_h.compact }
      resources.each do | resource |
        resource = embed_resources(resource) unless resource[:type] == "BLOOD"
      end
      instance_variable_set("@#{resource_name}", resources)
    end

    def embed_resources(resource ={})
      resource[:specimen_shipments] = NciMatchPatientModels::Shipment.scan(build_query({:surgical_event_id => resource[:surgical_event_id]})).collect { |data| data.to_h.compact }
      resource[:specimen_shipments].each do | shipment |
        shipment[:analyses] = NciMatchPatientModels::VariantReport.scan(build_query({:molecular_id => shipment[:molecular_id]})).collect { |data| data.to_h.compact }
      end
      resource[:assignment_report_status] = NciMatchPatientModels::Assignment.scan(build_query({:patient_id => resource[:patient_id], :projection => [:status, :status_date]}))
                                                .collect{|data| data.to_h.compact}.sort_by!{|record| record[:status_date]}.first
      resource[:variant_report_status] = "PENDING"
    end

    def specimen_events_params
      build_query({:patient_id => params.require(:patient_id)})
    end

  end
end
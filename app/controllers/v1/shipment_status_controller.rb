module V1
  class ShipmentStatusController < BaseController

    def show
      render json: instance_variable_get("@#{resource_name}")
    end

    private
    def set_resource(resource = nil)
      puts "=============== params: #{params[:id]}"
      shipments = NciMatchPatientModels::Shipment.find_by({"molecular_id" => params[:id]}).collect { |data| data.to_h.compact.deep_symbolize_keys! }
      return instance_variable_set("@#{resource_name}", {}) if shipments.length == 0

      patient_id = shipments.first[:patient_id]
      puts "================ patient id: #{patient_id}"

      variant_reports = NciMatchPatientModels::VariantReport.query_by_patient_id(patient_id, false).collect { |data| data.to_h.compact.deep_symbolize_keys! }
      instance_variable_set("@#{resource_name}", construct_shipment_status(variant_reports, patient_id, params[:id]))
    end

    def construct_shipment_status(variant_reports, patient_id, molecular_id)
      reports = variant_reports.select { | variant_report | variant_report[:molecular_id] == molecular_id}
      analysis_ids = []
      shipment_status = {:patient_id => patient_id, :molecular_id => molecular_id, :eligible_for_new_variant_report => true}
      reports.each do | report |
        analysis_ids << report[:analysis_id]
        shipment_status[:eligible_for_new_variant_report] = false if report[:status] == 'CONFIRMED'
      end
      shipment_status[:analysis_ids] = analysis_ids
      shipment_status
    end
  end
end

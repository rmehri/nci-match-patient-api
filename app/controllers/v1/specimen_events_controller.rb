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
      resource[:specimen_shipments].collect do | shipment |
        shipment[:analyses] = NciMatchPatientModels::Assignment.scan(build_query({:molecular_id => shipment[:molecular_id],
                                                                                  :projection => [:analysis_id, :status,
                                                                                                  :status_date, :comment_user,
                                                                                                  :comment]})).collect{|record| record[:assignment_report_status] = record.delete!(:status) }
        shipment[:analyses] += NciMatchPatientModels::VariantReport.scan(build_query({:molecular_id => shipment[:molecular_id],
                                                                                     :projection => [:variant_report_received_date, :dna_bam_path_name, :dna_bai_path_name,
                                                                                                     :vcf_path_name, :rna_bam_path_name, :rna_bai_path_name, :tsv_path_name,
                                                                                                     :status ,:qc_report_url, :vr_chart_data_url]})).collect{|record| record[:variant_report_status] = record.delete!(:status) }
      end
    end

    def specimen_events_params
      build_query({:patient_id => params.require(:patient_id)})
    end

  end
end
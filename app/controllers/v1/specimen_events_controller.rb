module V1
  class SpecimenEventsController < BaseController
    before_action :set_resource, only: [:index]

    # Combination of Specimen with Shipments, Events, Variant_reports
    def index
      render json: instance_variable_get("@#{resource_name}")
    end

    private
    def set_resource(_resource = {})
      resources_by_type = {}

      tissue_specimens = []
      blood_specimens = []

      resources = NciMatchPatientModels::Specimen.scan(resource_params).collect { |data| data.to_h.compact }

      resources.each do | resource |
        if (resource[:specimen_type] == 'TISSUE')
          tissue_specimens.push(resource)
        else
          blood_specimens.push(resource)
        end
      end

      tissue_specimens = tissue_specimens.sort_by{ |specimen| specimen[:collected_date]}.reverse
      latest_specimen = true
      tissue_specimens.each do | tissue_specimen |
        embed_resources(tissue_specimen, latest_specimen)
        latest_specimen = false
      end

      blood_shipments = embed_blood_shipment_resources
      blood_specimens = blood_specimens.sort_by {|blood_specimen| blood_specimen[:collected_date]}.reverse
      blood_resources = {:specimens => blood_specimens, :specimen_shipments => blood_shipments}


      resources_by_type[:tissue_specimens] = tissue_specimens
      resources_by_type[:blood_specimens] = blood_resources
      instance_variable_set("@#{resource_name}", resources_by_type)
    end

    def set_allow_upload(variant_report_confirmed, clia_lab, latest_specimen)

      return false if variant_report_confirmed
      return false if !latest_specimen
      return false if !is_variant_report_reviewer(clia_lab)

      patient = NciMatchPatientModels::Patient.query_patient_by_id(params[:patient_id])
      return false if patient.current_status == "OFF_STUDY" || patient.current_status == "REQUEST_NO_ASSIGNMENT"

      true
    end

    def embed_resources(resource ={}, latest_specimen)
      resource[:specimen_shipments] = NciMatchPatientModels::Shipment.scan(build_index_query({:surgical_event_id => resource[:surgical_event_id]})).collect { |data| data.to_h.compact }

      resource[:specimen_shipments].collect do | shipment |
        assignments = NciMatchPatientModels::Assignment.scan(build_index_query({:molecular_id => shipment[:molecular_id], :projection => [:analysis_id, :status, :status_date, :uuid, :comment_user,:comment]})).collect{|record| record.to_h.compact}
        variant_reports = NciMatchPatientModels::VariantReport.scan(build_index_query({:molecular_id => shipment[:molecular_id],
                                                                                       :projection => [:ion_reporter_id, :molecular_id, :analysis_id, :variant_report_received_date, :comment_user, :clia_lab,
                                                                                                       # :dna_bam_path_name, :dna_bai_path_name, :vcf_path_name, :rna_bam_path_name, :rna_bai_path_name, :tsv_file_name,
                                                                                                       :status ,:qc_report_url, :vr_chart_data_url]})).collect{|record| record.to_h.compact }

        variant_reports = variant_reports.sort_by{ |report| report[:variant_report_received_date]}.reverse

        assignments = assignments.sort_by{ |record| record[:assignment_date]}.reverse
        shipment[:analyses] = []
        variant_report_confirmed = false
        clia_lab = ""
        variant_reports.each do | variant_report |
          analysis_assignments = []
          assignments.each do | assignment |
            if(variant_report[:analysis_id] == assignment[:analysis_id])
              analyses_assignment = build_analyses_assignment_model(assignment)
              analysis_assignments << analyses_assignment
            end
          end

          variant_report_confirmed = true if variant_report[:status] == "CONFIRMED"
          clia_lab = variant_report[:clia_lab]

          variant_report_hash = build_variant_report_analyses_model(variant_report)
          variant_report_hash[:assignments] = analysis_assignments.sort_by {|assignment| assignment[:status_date]}.reverse
          shipment[:analyses] += [variant_report_hash]
        end

        # allow_upload
        shipment[:allow_upload] = set_allow_upload(variant_report_confirmed, clia_lab, latest_specimen) if shipment[:shipment_type] == "TISSUE_DNA_AND_CDNA"
      end

      resource
    end

    def embed_blood_shipment_resources

      resources = NciMatchPatientModels::Shipment.scan(build_index_query({:patient_id => params[:patient_id], :shipment_type => 'BLOOD_DNA'})).collect { |data| data.to_h.compact }

      resources = resources.sort_by{ |shipment| shipment[:shipped_date]}.reverse

      latest = true
      resources.collect do | shipment |
        variant_reports = NciMatchPatientModels::VariantReport.scan(build_index_query({:molecular_id => shipment[:molecular_id],
                                                                                       :projection => [:ion_reporter_id, :molecular_id, :analysis_id, :clia_lab, :variant_report_received_date, :status]})).collect{|record| record.to_h.compact }

        variant_reports = variant_reports.sort_by{ |report| report[:variant_report_received_date]}.reverse



        shipment[:analyses] = []
        variant_report_confirmed = false
        clia_lab = ""
        variant_reports.each do | variant_report |
          variant_report_confirmed = true if variant_report[:status] == "CONFIRMED"
          clia_lab = variant_report[:clia_lab]

          shipment[:analyses] += [build_variant_report_analyses_model(variant_report)]
        end

        shipment[:allow_upload] = set_allow_upload(variant_report_confirmed, clia_lab, latest)
        latest = false
      end

      resources
    end

    def specimen_events_params
      build_index_query({:patient_id => params.require(:patient_id)})
    end

    def build_variant_report_analyses_model(variant_report)
      return {} if variant_report.blank?

      report = {:ion_reporter_id => variant_report[:ion_reporter_id],
                :molecular_id => variant_report[:molecular_id],
                :analysis_id => variant_report[:analysis_id],
                :variant_report_status => variant_report[:status],
                :variant_report_received_date => variant_report[:variant_report_received_date],
                :comment_user => variant_report[:comment_user]
        }

      VariantReportHelper.add_download_links(report)
    end

    def build_analyses_assignment_model(assignment)
      if assignment.blank?
        {}
      else
        {
          :analysis_id => assignment[:analysis_id],
          :assignment_report_status => assignment[:status],
          :status_date => assignment[:status_date],
          :comment_user => assignment[:comment_user],
          :comment => assignment[:comment],
          :assignment_uuid => assignment[:uuid]
        }
      end
    end
  end
end
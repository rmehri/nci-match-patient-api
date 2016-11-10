module V1
  class SpecimenEventsController < BaseController
    before_action :set_resource, only: [:index]

    #Combination of Specimen with Shipments, Events, Variant_reports
    def index
      render json: instance_variable_get("@#{resource_name}")
    end

    private
    def set_resource(resource = {})
      tissue_specimens = []
      resources_by_type = {}

      resources = NciMatchPatientModels::Specimen.scan(resource_params).collect { |data| data.to_h.compact }

      resources.each do | resource |
        if (resource[:specimen_type] == 'TISSUE')
          resource = embed_resources(resource)
          tissue_specimens.push(resource)
        else
          embed_blood_specimens(resource, resources_by_type)
          embed_blood_shipment_resources(resource, resources_by_type)
        end

      end

      resources_by_type[:tissue_specimens] = tissue_specimens
      instance_variable_set("@#{resource_name}", resources_by_type)
    end

    def embed_resources(resource ={})
      resource[:specimen_shipments] = NciMatchPatientModels::Shipment.scan(build_index_query({:surgical_event_id => resource[:surgical_event_id]})).collect { |data| data.to_h.compact }
      resource[:specimen_shipments].collect do | shipment |
        assignments = NciMatchPatientModels::Assignment.scan(build_index_query({:molecular_id => shipment[:molecular_id], :projection => [:analysis_id, :status, :status_date, :comment_user,:comment]})).collect{|record| record.to_h.compact}
        variant_reports = NciMatchPatientModels::VariantReport.scan(build_index_query({:molecular_id => shipment[:molecular_id],
                                                                                       :projection => [:ion_reporter_id, :molecular_id, :analysis_id, :variant_report_received_date, :dna_bam_path_name, :dna_bai_path_name,
                                                                                                       :vcf_path_name, :rna_bam_path_name, :rna_bai_path_name, :tsv_file_name,
                                                                                                       :status ,:qc_report_url, :vr_chart_data_url]})).collect{|record| record.to_h.compact }
        assignments = assignments.sort_by{ |record| record[:assignment_date]}.reverse
        shipment[:analyses] = []
        variant_reports.each do | variant_report |
          analyses_assignment = Hash.new
          assignments.each do | assignment |
            if(variant_report[:analysis_id] == assignment[:analysis_id])
              analyses_assignment = build_analyses_assignment_model(assignment)
              break
            end
          end
          shipment[:analyses] += [build_variant_report_analyses_model(variant_report).merge(analyses_assignment)]
        end
      end

      resource
    end

    def embed_blood_specimens(resource, blood_shipment_resources)
      blood_shipment_resources[:blood_specimens] ||= []
      blood_shipment_resources[:blood_specimens].push(resource)
    end

    def embed_blood_shipment_resources(resource ={}, blood_shipment_resources)

      blood_shipment_resources[:blood_shipments] = NciMatchPatientModels::Shipment.scan(build_index_query({:patient_id => resource[:patient_id], :shipment_type => 'BLOOD_DNA'})).collect { |data| data.to_h.compact }
      blood_shipment_resources[:blood_shipments].collect do | shipment |
        variant_reports = NciMatchPatientModels::VariantReport.scan(build_index_query({:molecular_id => shipment[:molecular_id],
                                                                                       :projection => [:analysis_id, :variant_report_received_date, :dna_bam_path_name, :dna_bai_path_name,
                                                                                                       :vcf_path_name, :rna_bam_path_name, :rna_bai_path_name, :tsv_file_name,
                                                                                                       :status ,:qc_report_url, :vr_chart_data_url]})).collect{|record| record.to_h.compact }
        shipment[:analyses] = []
        variant_reports.each do | variant_report |
          shipment[:analyses] += [build_variant_report_analyses_model(variant_report)]
        end
      end
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
                :variant_report_received_date => variant_report[:variant_report_received_date]
        }

      add_download_links(report)
    end

    def add_download_links(variant_report)
      s3_file_folder = "#{variant_report[:ion_reporter_id]}/#{variant_report[:molecular_id]}/#{variant_report[:analysis_id]}/"
      files = Aws::S3::S3Reader.get_file_set(Rails.configuration.environment.fetch('s3_bucket'), s3_file_folder)

      add_vcf_link(variant_report, files)
      add_bam_links(variant_report, files)
      add_bai_links(variant_report, files)

      variant_report
    end

    def add_bai_links(variant_report, files)
      targets = files.select { |f| f[:file_path_name].end_with? ".bai"}
      return if targets.length == 0

      targets = targets.sort_by{|target| target[:size]}
      variant_report[:dna_bai_path_name] = targets[0][:public_url]
      variant_report[:rna_bai_path_name] = targets[1][:public_url] if targets.length > 1
    end

    def add_bam_links(variant_report, files)
      targets = files.select { |f| f[:file_path_name].end_with? ".bam"}
      return if targets.length == 0

      targets = targets.sort_by{|target| target[:size]}
      variant_report[:dna_bam_path_name] = targets[0][:public_url]
      variant_report[:rna_bam_path_name] = targets[1][:public_url] if targets.length > 1
    end

    def add_vcf_link(variant_report, files)

      targets = files.select { |f| f[:file_path_name].end_with? ".vcf"}
      return if targets.length == 0
      variant_report[:vcf_path_name] = targets[0][:public_url]
    end

    def build_analyses_assignment_model(assignment)
      (assignment.blank?) ? {} :
      {
          :analysis_id => assignment[:analysis_id],
          :assignment_report_status => assignment[:status],
          :status_date => assignment[:status_date],
          :comment_user => assignment[:comment_user],
          :comment => assignment[:comment],
      }
    end

  end
end
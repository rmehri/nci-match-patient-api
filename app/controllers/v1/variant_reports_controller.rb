module V1
  class VariantReportsController < BaseController

    def index
      begin

        plural_resource_name = "@#{resource_name.pluralize}"

        variant_reports_ui = []

        variant_reports = get_variant_report
        variant_reports.each do | variant_report|
          variants = get_variants(variant_report[:analysis_id])
          amois = get_amois(variant_report)

          variant_report = Convert::VariantReportDbModel.to_ui_model(variant_report, variants, amois)
          variant_reports_ui.push(variant_report)
        end

        instance_variable_set(plural_resource_name, variant_reports_ui)
        instance_variable_get(plural_resource_name)

        render json: instance_variable_get(plural_resource_name)
      rescue => error
        standard_error_message(error.message)
      end
    end

    private

    def get_variant_report
      variant_reports = NciMatchPatientModels::VariantReport.scan(query_params).collect { |data| data.to_h.compact }
      raise "Patient doesn't have a variant report matching parameters [#{params}]" if variant_reports.length == 0

      variant_reports
    end

    def get_variants(analysis_id)
      NciMatchPatientModels::Variant.scan(build_query({:analysis_id => analysis_id})).collect { |data| data.to_h.compact }
    end

    def get_amois(variant_report)
      VariantReportUpdater.new.updated_variant_report(variant_report)
    end

    def query_params
      parameters = params.permit(:patient_id, :variant_report_received_date, :variant_report_type,
                                 :molecular_id, :analysis_id, :status, :status_date, :comment,
                                 :comment_user, :dna_bam_name, :dna_bai_name, :rna_bam_name, :rna_bai_name,
                                 :vcf_file_name, :tsv_file_name, :total_variants, :cellularity, :total_mois,
                                 :total_amois, :total_confirmed_mois, :total_confirmed_amois,
                                 :specimen_received_date, :clia_lab,
                                 :attributes, :projections, :projection => [], :attribute => [])
      build_query(parameters)

    end

  end
end

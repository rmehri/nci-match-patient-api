module V1
  class AnalysisReportController < ApplicationController
    def analysis_view
      begin
        patient = NciMatchPatientModels::Patient.query_patient_by_id(params[:patient_id])
        rails "Patient not found" if patient.blank?

        variant_report_hash = NciMatchPatientModelExtensions::VariantReportExtension.compose_variant_report({:patient_id => params[:patient_id],
                                                                                                             :analysis_id => params[:analysis_id]})

        assignments = NciMatchPatientModels::Assignment.query_by_patient_id(params[:patient_id], false).collect { |data| data.to_h.compact }
        assignments = assignments.sort_by{| assignment | assignment[:assignment_date]}.reverse

        assignments_with_assays = []
        assignments.each do | assignment |
          assays = find_assays(assignment[:surgical_event_id]) unless assignment[:surgical_event_id].blank?
          assignments_with_assays.push(Convert::AssignmentDbModel.to_ui(assignment, assays)) unless assignment.blank?
        end

        analysis_report = Convert::AnalysisReportDbModel.to_ui_model(patient.to_h.compact, variant_report_hash, assignments_with_assays)

        render json: analysis_report.to_json

      rescue => exception
        standard_error_message(exception.message)
      end
    end

    def amois_update
      begin

        raise "Patient_id and analysis_id are required" if params[:patient_id].nil? || params[:analysis_id].nil?

        variant_report = NciMatchPatientModels::VariantReport.query_by_analysis_id(params[:patient_id], params[:analysis_id])
        return standard_error_message("No record found", 404) if variant_report.blank?

        amois = get_amois(variant_report.to_h.deep_symbolize_keys!)

        match_amoi_with_uuid(amois)

        render json: Convert::AmoisRuleModel.to_ui_model(amois).to_json
      rescue => error
        standard_error_message(error.message)
      end
    end

    private
    def find_assays(surgical_event_id)
      assays = []
      specimens = NciMatchPatientModels::Specimen.find_by({:surgical_event_id => surgical_event_id}).collect { |data| data.to_h.compact }
      assays = specimens[0][:assays] if specimens.length > 0
      assays
    end

    def get_variants(analysis_id)
      NciMatchPatientModels::Variant.scan(build_query({:analysis_id => analysis_id})).collect { |data| data.to_h.compact }
    end

    def get_amois(variant_report)
      VariantReportUpdater.new.updated_variant_report(variant_report)
    end

    def match_amoi_with_uuid(amois)
      find_amoi_uuid(amois[:snv_indels])
      find_amoi_uuid(amois[:copy_number_variants])
      find_amoi_uuid(amois[:gene_fusions])

    end

    def find_amoi_uuid(amois)
      amois.each do | amoi |
        query_hash = {:variant_type => amoi[:variant_type]}
        query_hash[:identifier] = amoi[:idenfitier] if !amoi[:idenfitier].blank?
        query_hash[:chromosome] = amoi[:chromosome] if !amoi[:chromosome].blank?
        query_hash[:func_gene] = amoi[:chromosome] if !amoi[:func_gene].blank?
        query_hash[:chromosome] = amoi[:chromosome] if !amoi[:chromosome].blank?
        query_hash[:position] = amoi[:position] if !amoi[:position].blank?
        query_hash[:reference] = amoi[:reference] if !amoi[:reference].blank?
        query_hash[:alternative] = amoi[:alternative] if !amoi[:alternative].blank?
        query_hash[:position] = amoi[:position] if !amoi[:position].blank?

        variants = NciMatchPatientModels::Variant.find_by(query_hash).collect { |data| data.to_h.compact }
        if (variants.length > 0)
          puts "=============== va match: #{variants[0]}"
          amoi[:uuid] = variants[0][:uuid]
        end
      end
    end
  end
end

module V1
  class AnalysisReportController < ApplicationController
    before_action :authenticate_user
    def analysis_view
        patient = NciMatchPatientModels::Patient.query_patient_by_id(params[:patient_id])

        variant_report_hash = NciMatchPatientModelExtensions::VariantReportExtension.compose_variant_report(params[:patient_id], params[:analysis_id])
        VariantReportHelper.add_download_links(variant_report_hash)

        assignments = NciMatchPatientModels::Assignment.query_by_patient_id(params[:patient_id], false).collect { |data| data.to_h.compact }
        assignments = assignments.sort_by{| assignment | assignment[:assignment_date]}.reverse

        assignments_with_assays = []
        assignments.each do | assignment |
          assays = find_assays(assignment[:surgical_event_id])
          assignments_with_assays.push(Convert::AssignmentDbModel.to_ui(assignment, assays)) unless assignment.blank?
        end
        analysis_report = Convert::AnalysisReportDbModel.to_ui_model(patient.to_h.compact, variant_report_hash, assignments_with_assays)
        render json: analysis_report.to_json
    end

    def amois_update
        raise "Patient_id and analysis_id are required" if params[:patient_id].nil? || params[:analysis_id].nil?
        variant_report = NciMatchPatientModels::VariantReport.query_by_analysis_id(params[:patient_id], params[:analysis_id])

        variant_report_hash = variant_report.to_h
        mois = get_amois(variant_report_hash.deep_symbolize_keys!)
        match_amois_with_uuid(variant_report_hash, mois)

        render json: Convert::AmoisRuleModel.to_ui_model(mois).to_json
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

    def match_amois_with_uuid(variant_report, mois)
      find_amoi_uuid(variant_report, mois[:snv_indels])
      find_amoi_uuid(variant_report, mois[:copy_number_variants])
      find_amoi_uuid(variant_report, mois[:gene_fusions])

    end

    def find_amoi_uuid(variant_report, mois)
      return if mois.blank?

      mois.each do | moi |
        next if moi[:mois].blank?

        query_hash = {:patient_id => variant_report[:patient_id],
                      :molecular_id => variant_report[:molecular_id],
                      :analysis_id => variant_report[:analysis_id],
                      :variant_type => moi[:variant_type]}

        query_hash[:surgical_event_id] = variant_report[:surgical_event_id] if variant_report[:surgical_event_id].blank?
        query_hash[:identifier] = moi[:idenfitier] if !moi[:idenfitier].blank?
        query_hash[:func_gene] = moi[:func_gene] if !moi[:func_gene].blank?
        query_hash[:chromosome] = moi[:chromosome] if !moi[:chromosome].blank?
        query_hash[:position] = moi[:position] if !moi[:position].blank?
        query_hash[:reference] = moi[:reference] if !moi[:reference].blank?
        query_hash[:alternative] = moi[:alternative] if !moi[:alternative].blank?
        query_hash[:position] = moi[:position] if !moi[:position].blank?

        variants = NciMatchPatientModels::Variant.find_by(query_hash).collect { |data| data.to_h.compact }

        if (variants.length > 0)
          moi[:uuid] = variants[0][:uuid]
        end
      end

    end
  end
end

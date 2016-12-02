module V1
  class AnalysisReportAmoisController < BaseController
    # before_action :authenticate_user

    def show
      render json: instance_variable_get("@#{resource_name}")
    end

    private
    def set_resource(resource = {})
      variant_report = NciMatchPatientModels::VariantReport.query_by_analysis_id(params[:patient_id], params[:id])
      raise Errors::ResourceNotFound if variant_report.nil?

      variant_report_hash = variant_report.to_h
      mois = get_amois(variant_report_hash.deep_symbolize_keys!)
      match_amois_with_uuid(variant_report_hash, mois)

      instance_variable_set("@#{resource_name}", Convert::AmoisRuleModel.to_ui_model(mois).to_json)
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
        next if moi[:amois].blank?
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

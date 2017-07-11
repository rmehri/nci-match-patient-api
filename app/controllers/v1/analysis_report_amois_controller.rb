module V1
  class AnalysisReportAmoisController < BaseController
    before_action :authenticate_user
    include Knock::Authenticable

    def show
      render json: instance_variable_get("@#{resource_name}")
    end

    private

    def set_resource(_resource = {})
      variant_report = NciMatchPatientModels::VariantReport.query_by_analysis_id(params[:patient_id], params[:id])
      raise Errors::ResourceNotFound if variant_report.nil?

      variant_report_hash = variant_report.to_h.deep_symbolize_keys!
      treatment_arms_updated = Rails.cache.fetch("treatment_arms_updated") { Time.now.to_i }
      if(treatment_arms_updated > DateTime.parse(variant_report_hash[:amoi_updated_date]))
        mois = get_amois(variant_report_hash)
        amoi_count = match_amois_with_uuid(variant_report_hash, mois)
        updated_amois = Convert::AmoisRuleModel.to_ui_model(mois)
        #send to backend to be saved!
      else
        variants = NciMatchPatientModels::Variant.find_by({:analysis_id => variant_report_hash[:analysis_id]})
        updated_amois = Convert::AmoisRuleModel.find_amois(variants)
        amoi_count = updated_amois[:total_amois]
      end
      update_amoi_count_in_variant_report(variant_report, amoi_count)

      instance_variable_set("@#{resource_name}", updated_amois.to_json)
    end

    def get_amois(variant_report)
      VariantReportUpdater.new.updated_variant_report(variant_report, request.uuid, token)
    end

    def match_amois_with_uuid(variant_report, mois)
      amoi_count = find_amoi_uuid(variant_report, mois[:snv_indels])
      amoi_count += find_amoi_uuid(variant_report, mois[:copy_number_variants])
      amoi_count += find_amoi_uuid(variant_report, mois[:gene_fusions])
      amoi_count
    end

    def find_amoi_uuid(variant_report, mois)
      amoi_count = 0
      return amoi_count if mois.blank?

      mois.each do | moi |
        moi.deep_symbolize_keys!
        next if moi[:amois].blank?
        amoi_count += 1
        query_hash = {
                       patient_id: variant_report[:patient_id],
                       molecular_id: variant_report[:molecular_id],
                       analysis_id: variant_report[:analysis_id],
                       variant_type: moi[:variant_type]
                     }

        query_hash[:surgical_event_id] = variant_report[:surgical_event_id] if variant_report[:surgical_event_id].blank?
        query_hash[:identifier] = moi[:identifier] unless moi[:identifier].blank?
        query_hash[:func_gene] = moi[:func_gene] unless moi[:func_gene].blank?
        query_hash[:chromosome] = moi[:chromosome] unless moi[:chromosome].blank?
        query_hash[:position] = moi[:position] unless moi[:position].blank?
        query_hash[:reference] = moi[:reference] unless moi[:reference].blank?
        query_hash[:alternative] = moi[:alternative] unless moi[:alternative].blank?
        query_hash[:position] = moi[:position] unless moi[:position].blank?
        query_hash[:driver_gene] = moi[:driver_gene] unless moi[:driver_gene].blank?
        query_hash[:partner_gene] = moi[:partner_gene] unless moi[:partner_gene].blank?

        variants = NciMatchPatientModels::Variant.find_by(query_hash).collect { |data| data.to_h.compact }

        if (variants.length > 0)
          moi[:uuid] = variants[0][:uuid]
        end
      end

      amoi_count
    end

    def update_amoi_count_in_variant_report(variant_report, amoi_count)
      if (variant_report.total_amois != amoi_count)
        variant_report.total_amois = amoi_count
        variant_report.save
        AppLogger.log(self.class.name, "Amoi count updated for patient [#{variant_report.patient_id}]")
      end
    end

  end
end

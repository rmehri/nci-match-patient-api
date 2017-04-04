module V1
  class AnalysisReportAmoisController < BaseController
    # before_action :authenticate_user
    # include Knock::Authenticable

    def show
      render json: instance_variable_get("@#{resource_name}")
    end

    private

    def set_resource(_resource = {})
      variant_report = NciMatchPatientModels::VariantReport.query_by_analysis_id(params[:patient_id], params[:id])
      raise Errors::ResourceNotFound if variant_report.nil?

      variant_report_hash = variant_report.to_h
      mois = get_amois(variant_report_hash.deep_symbolize_keys!)
      match_amois_with_uuid(variant_report_hash, mois)

      updated_amois = Convert::AmoisRuleModel.to_ui_model(mois)
      # queue_to_save_updated_amois(params[:patient_id], params[:id], updated_amois)
      instance_variable_set("@#{resource_name}", updated_amois.to_json)
    end

    def get_amois(variant_report)
      VariantReportUpdater.new.updated_variant_report(variant_report, request.uuid, token)
    end

    def match_amois_with_uuid(variant_report, mois)
      find_amoi_uuid(variant_report, mois[:snv_indels])
      find_amoi_uuid(variant_report, mois[:copy_number_variants])
      find_amoi_uuid(variant_report, mois[:gene_fusions])
    end

    def find_amoi_uuid(variant_report, mois)
      return if mois.blank?

      mois.each do | moi |
        moi.deep_symbolize_keys!
        next if moi[:amois].blank?
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
    end

    def queue_to_save_updated_amois(patient_id, analysis_id, updated_amois)
      message = {:patient_id => patient_id, :analysis_id => analysis_id, updated_amois => updated_amois}
      queue_name = Rails.configuration.environment.fetch('queue_name')
      logger.debug "Analysis_report_amois publishing to queue: #{queue_name}..."
      Aws::Sqs::Publisher.publish(message, queue_name)
    end
  end
end

module VariantReportUpdater

  def self.updated_variant_report(variant_report, uuid, token)

    begin
      treatment_arms = TreatmentArmApi.get_treatment_arms(uuid, token)
      report = RuleEngine.get_mois(variant_report[:patient_id],
                          variant_report[:ion_reporter_id],
                          variant_report[:molecular_id],
                          variant_report[:analysis_id],
                          variant_report[:tsv_file_name],
                          treatment_arms, uuid, token)

      mois_from_rule = JSON.parse(report)
      mois_from_rule.deep_symbolize_keys
    rescue => ex
      AppLogger.log_error(self.class.name, "Got error while getting updated variant report: #{ex.message}")
      raise ex
    end

  end
end

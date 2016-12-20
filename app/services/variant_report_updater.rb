
class VariantReportUpdater
  attr_accessor :patient_id, :ion_reportter_id, :molecular_id, :analysis_id, :tsv_file_name

  def updated_variant_report(variant_report, token)

    begin
      treatment_arms = TreatmentArmApi.get_treatment_arms(token)
      report = RuleEngine.get_mois(variant_report[:patient_id],
                          variant_report[:ion_reporter_id],
                          variant_report[:molecular_id],
                          variant_report[:analysis_id],
                          variant_report[:tsv_file_name],
                          treatment_arms, token)

      variant_report = JSON.parse(report)
      variant_report.deep_symbolize_keys
    rescue => ex
      AppLogger.log_error(self.class.name, "Got error while getting updated variant report: #{ex.message}")
      raise ex
    end

  end
end
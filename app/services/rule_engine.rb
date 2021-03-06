class RuleEngine
  include HTTParty
  default_timeout 60

  base_uri Rails.configuration.environment.fetch("match_rule_api")

  def self.get_mois(patient_id, ion_reporter_id, molecular_id, analysis_id, tsv_name, treatment_arms, uuid ,token="")

    tsv_file_name = File.basename(tsv_name, ".tsv")
    service_url = base_uri + "/variant_report/#{patient_id}/#{ion_reporter_id}/#{molecular_id}/#{analysis_id}/#{tsv_file_name}?filtered=true"
    # service_url = base_uri + "/variant_report/amois"

    AppLogger.log(self.class.name, "Calling out to service #{service_url}...")
    begin
      options = {
          body: treatment_arms,
          headers: { 'X-Request-Id' => uuid, 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{token}"}
      }

      response = post(service_url, options)
      raise "Error code [#{response.code}] received from Rule Engine" if (response.code != 200)
      response.body

    rescue => error
      AppLogger.log_error(self.class.name, "Exception while calling Rule Engine: #{error.message}")
      raise error
    end
  end
end

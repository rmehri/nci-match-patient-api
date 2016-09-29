
class RuleEngine
  include HTTParty

  base_uri ENV["match_rule_api"]

  def self.get_mois(patient_id, ion_reporter_id, molecular_id, analysis_id, tsv_name, treatment_arms)

    tsv_file_name = File.basename(tsv_name, ".tsv")
    service_url = base_uri + "/variant_report/#{patient_id}/#{ion_reporter_id}/#{molecular_id}/#{analysis_id}/#{tsv_file_name}?filtered=true"
    # service_url = base_uri + "/variant_report/#{patient_id}/#{ion_reporter_id}/#{molecular_id}/job1/#{tsv_file_name}?filtered=true"
    Shoryuken.logger.info "#{self.class.name} | Calling out to service #{service_url}..."

    begin
      options = {
          body: treatment_arms,
          headers: { 'Content-Type' => 'application/json' }
      }

      response = post(service_url, options)
      # raise "Error code [#{response.code}] received from Rule Engine" if (response.code != 200)
      response

    rescue => error
      #TODO: if RuleEngine is down, put message in queue and try it again later
      # error example: "Connection refused - connect(2) for "127.0.0.1" port 10250"
      Shoryuken.logger.error "#{self.class.name} | Exception while calling Rule Engine: #{error.message}"
      raise error
    end
  end

  def self.assign_patient(patient_id, patient_json)

    Shoryuken.logger.info "#{self.class.name} | Calling out to Rule Engine for patient assignment..."
    begin

      service_url = base_uri + "/assignment_report/#{patient_id}"

      options = {
          body: patient_json,
          headers: { 'Content-Type' => 'application/json' }
      }
      response = post(service_url, options)

      Shoryuken.logger.info "#{self.class.name} | Response code: #{response.code}"
      # Shoryuken.logger.info "#{self.class.name} | Response body: #{response.body}"

      response

    rescue => error
      #TODO: if RuleEngine is down, put message in queue and try it again later
      # error example: "Connection refused - connect(2) for "127.0.0.1" port 10250"
      Shoryuken.logger.info "#{self.class.name} | Exception while calling Rule Engine: #{error.message}"
      raise error
    end
  end

end
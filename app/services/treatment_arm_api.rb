
class TreatmentArmApi
  include HTTParty

  base_uri ENV["treatment_arm_api"]

  def self.get_treatment_arms(refresh_flag)
    Shoryuken.logger.info "#{self.class.name} | Getting treatment arms from Treatment Arm Api..."

    begin
      url = base_uri + "?active=true"
      url += "&refresh=true" if refresh_flag
      Shoryuken.logger.info "#{self.class.name} | Calling Treatment Arm Api: #{url}"

      response = get(url)
      Shoryuken.logger.info "#{self.class.name} | Done calling Treatment Arm Api with response code #{response.code}"

      response
    rescue Error => error
      #TODO: need to queue request
      Shoryuken.logger.error "#{self.class.name} | Got exception from Treatment Arm Api: #{error.message}"
      raise error
    end
  end

  def self.notify_patient_assignement(treatment_id, stratum_id, version, message)
    Shoryuken.logger.info "#{self.class.name} | Notifying Treatment Arm Api on patient assignment: #{message}"

    service_url = base_uri + "/#{treatment_id}/#{stratum_id}/#{version}/assignment_event"
    Shoryuken.logger.info "#{self.class.name} | Treatment Arm Api on patient assignment url: #{service_url}"

    begin

      options = { body: message }
      response = post(service_url, options)

      if (response.code != 200)
        Shoryuken.logger.error "#{self.class.name} | Got #{response.code} from Treatment Arm Api"
        return false
      end

      Shoryuken.logger.info "#{self.class.name} | Success in notifying Treatment Arm Api on patient assignment"
      true
    rescue Error => error
      # Errno::ECONNREFUSED:
      # Connection refused - connect(2) for "localhost" port 3000

      p "================ error: #{error.message}"
    end
  end
end
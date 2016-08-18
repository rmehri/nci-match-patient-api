
module AppLogger
  def self.log(component_name, message)
    Rails.logger.info Time.now.strftime("%Y-%m-%d %H:%M:%S") + "Patient-API #{component_name}: #{message}"
  end

  def self.log_debug(component_name, message)
    Rails.logger.debug Time.now.strftime("%Y-%m-%d %H:%M:%S") + "Patient-API #{component_name}: #{message}"
  end

  def self.log_error(component_name, message)
    Rails.logger.error Time.now.strftime("%Y-%m-%d %H:%M:%S") + "Patient-API #{component_name}: #{message}"
  end
end
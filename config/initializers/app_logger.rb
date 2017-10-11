module AppLogger
  extend self

  def log(context, message)
    Rails.logger.info log_output(" #{context}", message, 'INFO') # space for alignment
  end

  def log_debug(context, message)
    Rails.logger.debug log_output(context, message, 'DEBUG')
  end

  def log_error(context, message)
    Rails.logger.error log_output(context, message, 'ERROR')
  end

  private

  def log_output(context, message, log_level)
    "[#{Time.now}] [#{Rails.application.class.parent}] [#{RequestStore.store[:uuid] || 'No request'}] [#{log_level}] #{context}: #{message}"
  end
end

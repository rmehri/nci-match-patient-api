class MessageJob < ActiveJob::Base

  queue_as "#{Rails.configuration.environment.fetch('queue_name')}"


end
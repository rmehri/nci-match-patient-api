module Config
  class Queue

    # Obsolete. ENV['queue_name'] shall have the full queue name to use
    def self.name(name)
      # input "name" is currently ignored since we only deal with one queue and
      # its name is configured in environment
      # prefix = ENV["queue_prefix"]
      # prefix = if (prefix.nil? || prefix.length == 0) then '' else prefix + '_' end

      _queue_name = Rails.configuration.environment.fetch('queue_name')
    end
  end
end

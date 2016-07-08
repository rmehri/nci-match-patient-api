module Config
  class Table
    def self.name(name)
      prefix = ENV["table_prefix"]
      prefix = if (prefix.nil? || prefix.length == 0) then '' else prefix + '_' end

      table_name = prefix + name.to_s + "_#{Rails.env}"
    end
  end

  class Queue
    def self.name(name)
      # input "name" is currently ignored since we only deal with one queue and
      # its name is configured in environment
      prefix = ENV["queue_prefix"]
      prefix = if (prefix.nil? || prefix.length == 0) then '' else prefix + '_' end

      queue_name = "#{prefix}#{ENV["queue_name"]}_#{Rails.env}"
    end
  end
end

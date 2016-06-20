module Config
  class Table
    def self.name(name)
      name = name.to_s.split('/').last || ''
      ENV["table_prefix"].to_s + name.to_s + ENV["table_suffix"].to_s
    end
  end

  class Queue
    def self.name(name)
      name = name.to_s.split('/').last || ''
      ENV["queue_prefix"].to_s + name.to_s + ENV["queue_suffix"].to_s
    end
  end
end

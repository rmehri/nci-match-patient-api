module Config
  class Table
    def self.name(name)
      ENV["table_prefix"] + name + ENV["table_suffix"]
    end
  end

  class Queue
    def self.name(name)
      ENV["queue_prefix"] + name + ENV["queue_suffix"]
    end
  end
end

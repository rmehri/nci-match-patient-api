module Aws
  module Record

    def self.ensure_table
      if (!self.table_exists?)
        migration = Aws::Record::TableMigration.new(self)
        migration.create!(provisioned_throughput: { read_capacity_units: 5, write_capacity_units: 5 })
        migration.wait_until_available
      end
    end

    module Ext
      def data_to_h
        JSON.parse(to_json)["data"]
      end
    end

  end
end
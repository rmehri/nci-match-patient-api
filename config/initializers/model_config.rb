# find all classes (models) in NciMatchPatientModels module
Models = NciMatchPatientModels.constants.reduce([]) do |acc, constant_symbol|
  constant = NciMatchPatientModels.const_get(constant_symbol)
  acc << constant if constant.is_a?(Class)
  acc
end

# filter dynamoDB models
DynamoDBModels = Models.select{|m| m.ancestors.include?(Aws::Record)} # some models are not dynamoDB models

# extend all dynamoDB models with a faster scan method
DynamoDBModels.each{|m| m.extend(Aws::DynamoDB::Helpers)}

# dynamoDB models configuration
module DynamoDBModelsConfig

  # configure each model
  def self.configure
    begin
      DynamoDBModels.each{|m| ensure_table(m)}
    rescue Aws::Errors::MissingCredentialsError => error
      p "Failed to ensure tables exists because of Credential issues"
    end
  end

  # create a table for a model
  def self.ensure_table(model)
    unless model.table_exists?
      migration = Aws::Record::TableMigration.new(model)
      migration.create!(provisioned_throughput: { read_capacity_units:  Rails.configuration.environment.fetch('read_capacity_units').to_i,
                                                  write_capacity_units: Rails.configuration.environment.fetch('write_capacity_units').to_i })
      migration.wait_until_available
    end
  end
end

# faster check if dynamoDB is running (default will fail after 25 seconds)
Aws::DynamoDB::Client.new(retry_limit: 5).list_tables rescue (puts('DynamoDB is not running'); exit)

# configure now
DynamoDBModelsConfig.configure

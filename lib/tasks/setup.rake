namespace :setup do

  task :before => :environment do
    add_env_variables(Rails.root.join('config', 'environment.yml'))
    add_env_variables(Rails.root.join('config', 'secrets.yml'))
  end

  task :create_table, [:name] => :before do | t, args |
    args.to_a.each do | arg |
      create_table("NciMatchPatientModels::#{arg.camelize}".constantize)
    end
  end

  task :delete_table, [:name] => :before do | t, args |
    args.to_a.each do | arg |
      delete_table("NciMatchPatientModels::#{arg.camelize}".constantize)
    end
  end

  task :clear_table, [:name] => :before do | t, args |
    args.to_a.each do | arg |
      clear_table("NciMatchPatientModels::#{arg.camelize}".constantize)
    end
  end


  def add_env_variables(env_file)
    if File.exists?(env_file)
      YAML.load_file(env_file)[Rails.env].each do |key, value|
        ENV[key.to_s] = value
      end
    end
  end

  def delete_table(model_class)
    if (model_class.table_exists?)
      migration = Aws::Record::TableMigration.new(model_class,
                                                  {:client => get_client(Aws::DynamoDB::Client)})
      migration.delete!
    else
      p "Table #{model_class.table_name} doesn't exists....skipping"
    end
  end

  def clear_table(model_class)
    if(model_class.table_exists?)
      model_class.scan({}).each do | record |
        record.delete!
      end
    else
      p "Table #{model_class.table_name} doesn't exists....skipping"
    end
  end

  def create_table(model_class)
    if (!model_class.table_exists?)
      migration = Aws::Record::TableMigration.new(model_class,
                                                  {:client => get_client(Aws::DynamoDB::Client)})
      migration.create!(
          provisioned_throughput: {
              read_capacity_units: Rails.configuration.environment.fetch("read_capacity_units").to_i,
              write_capacity_units: Rails.configuration.environment.fetch("write_capacity_units").to_i
          }
      )
      migration.wait_until_available
    else
      p "Table #{model_class.table_name} already exists....skipping"
    end
  end

  def get_client(client_type)
    client_type.new(endpoint: Rails.configuration.environment.fetch("aws_dynamo_endpoint"),
                              access_key_id: ENV["AWS_ACCESS_KEY_ID"],
                              secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
                              region: Rails.configuration.environment.fetch("aws_region"))
  end

end
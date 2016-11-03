namespace :setup do

  task :before => :environment do
    add_env_variables(Rails.root.join('config', 'environment.yml'))
    add_env_variables(Rails.root.join('config', 'secrets.yml'))
  end

  desc 'Loads json into specified table'
  task :load_date, [:table_name, :file] => :before do | t, args |
    model = "NciMatchPatientModels::#{args.table_name.camelize}".constantize
    data = File.read(args.file)
    data = JSON.parse(data).deep_symbolize_keys!
    model.new(data).save!
  end

  desc 'List all table names in environment DB'
  task :list_tables => :before do
    p list_tables
  end

  desc 'Creates table for API'
  task :create_table, [:name] => :before do | t, args |
    args.to_a.each do | arg |
      create_table("NciMatchPatientModels::#{arg.camelize}".constantize)
    end
  end

  desc 'Deletes all tables unless [tablename] is specified'
  task :delete_table, [:name] => :before do | t, args |
    args = list_tables unless !args.to_a.blank?
    args.to_a.each do | arg |
      begin
        delete_table("NciMatchPatientModels::#{arg.camelize}".constantize)
      rescue => NameError
        p "NciMatchPatientModels::#{arg.camelize} doesn't exist..make sure you have the right api"
      end
    end
  end

  desc 'Clears all table data unless [tablename] is specified'
  task :clear_table, [:name] => :before do | t, args |
    args = list_tables unless !args.to_a.blank?
    args.to_a.each do | arg |
      begin
        clear_table("NciMatchPatientModels::#{arg.camelize}".constantize)
      rescue => NameError
        p "NciMatchPatientModels::#{arg.camelize} doesn't exist..make sure you have the right api"
      end
    end
  end

  def list_tables
    get_client(Aws::DynamoDB::Client).list_tables({}).table_names
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
      migration = Aws::Record::TableMigration.new(model_class, {:client => get_client(Aws::DynamoDB::Client)})
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
      migration = Aws::Record::TableMigration.new(model_class, {:client => get_client(Aws::DynamoDB::Client)})
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
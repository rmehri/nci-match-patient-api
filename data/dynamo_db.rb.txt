require "aws-sdk-core"

class DynamoDb

  def initialize
    @dynamodb = Aws::DynamoDB::Client.new(endpoint: "http://localhost:8000",
                                          access_key_id: "random_act_of_awesome",
                                          secret_access_key: "random_act_of_awesome",
                                          region: "localhost")
  end

  def create_ta_table_params
    {table_name: "_treatment_arm",
     key_schema: [
         {
             attribute_name: "name",
             key_type: "HASH"  #Partition key
         },
         {
             attribute_name: "version",
             key_type: "RANGE"

         }

     ],
     attribute_definitions: [
         {
             attribute_name: "name",
             attribute_type: "S"
         },
         {
             attribute_name: "version",
             attribute_type: "S"
         }
     ],
     provisioned_throughput: {
         read_capacity_units: 10,
         write_capacity_units: 10
     }
    }
  end


  def create_patient_table_params
    {table_name: "_treatment_arm_patient",
     key_schema: [
         {
             attribute_name: "name", #(name_version) of treatment_arm
             key_type: "HASH"  #Partition key
         },
         {
             attribute_name: "patient_sequence_number",
             key_type: "RANGE"

         }

     ],
     attribute_definitions: [
         {
             attribute_name: "name",
             attribute_type: "S"
         },
         {
             attribute_name: "patient_sequence_number",
             attribute_type: "S"
         }
     ],
     provisioned_throughput: {
         read_capacity_units: 10,
         write_capacity_units: 10
     }
    }
  end

  def run
    begin
      p @dynamodb.list_tables()
      # @dynamodb.delete_table({table_name: "specimen_development"})
      table_date = @dynamodb.scan({table_name: "specimen_development"}).items
      table_date.each do | ta |
        p ta
      end
      # p @dynamodb.list_tables()
      # @dynamodb.create_table(create_patient_table_params())
      # @dynamodb.create_table(create_ta_table_params())
      # result = @dynamodb.scan({table_name: "ta_basic_treatment_arm_dev"})
      # p result.items.count
      #    result.items.each do | data |
      #      p data
      #    end
    rescue  Aws::DynamoDB::Errors::ServiceError => error
      puts "Unable to create tables:"
      puts "#{error.message}"
    end
  end

  DynamoDb.new.run

end

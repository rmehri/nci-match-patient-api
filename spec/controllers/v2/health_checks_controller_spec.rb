require 'rails_helper'


RSpec.describe V2::HealthChecksController, type: :controller do

  it{expect(get: '/api/v2/patients/health_checks').to route_to(controller: 'v2/health_checks', action: 'show')}

  it{expect(get :show).to be_truthy}

  it "will return corrrectly" do
    get :show
    expect(response.body).to eq({"dynamodb_connected"=>true, "queue_name"=>"patient_queue", "queue_connected"=>true}.to_json)
  end

  it "will not connect to sqs" do
    sqs_client = instance_double(Aws::SQS::Client)
    allow(Aws::SQS::Client).to receive(:new).and_return(sqs_client)
    allow(Shoryuken).to receive(:sqs_client).and_return(sqs_client)
    allow(sqs_client).to receive(:get_queue_url).and_return(nil)
    get :show
    expect(response.body).to eq({"dynamodb_connected"=>true, "queue_name"=>"patient_queue", "queue_connected"=>false}.to_json)
  end

  it "will not connect to DB" do
    db_client = instance_double(Aws::DynamoDB::Client)
    allow(Aws::DynamoDB::Client).to receive(:new).and_return(db_client)
    allow(db_client).to receive(:list_tables).and_return(nil)
    get :show
    expect(response.body).to eq({"dynamodb_connected"=>false, "queue_name"=>"patient_queue", "queue_connected"=>true}.to_json)
  end

end
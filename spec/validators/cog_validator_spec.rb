require 'rails_helper'

describe 'CogValidator behavior' do

  let(:good_message) do
    {
        "header"=> {
            "msg_guid" => "0f8fad5b-d9cb-469f-al65-80067728950e",
            "msg_dttm"=> "2016-05-09T22:06:33+00:00"
        },
        "study_id"=> "APEC1621",
        "patient_id"=> "3344",
        "step_number"=> "1.0",
        "registration_date"=> "2016-05-09T22:06:33+00:00",
        "status"=> "REGISTRATION",
        "internal_use_only"=> {
            "request_id"=> "4-654321",
            "environment"=> "4",
            "request"=> "REGISTRATION for patient_id 2222"
        }
    }
  end

  let(:bad_message) do
    {
        "header"=> {
            "msg_guid" => "0f8fad5b-d9cb-469f-al65-80067728950e",
            "msg_dttm"=> "2016-05-09T22:06:33+00:00"
        },
        "study_id"=> "APEC1621",
        "step_number"=> "1.0",
        "registration_date"=> "2016-05-09T22:06:33+00:00",
        "status"=> "REGISTRATION",
        "internal_use_only"=> {
            "request_id"=> "4-654321",
            "environment"=> "4",
            "request"=> "REGISTRATION for patient_id 2222"
        }
    }
  end

  it "should get type 'Cog' from MessageValidator" do
    type = MessageValidator.get_message_type(good_message.to_json)
    expect(type).to eq('Cog')
  end

  it "should validate a good message" do
    valid = JSON::Validator.validate(MessageValidator::CogValidator.schema, good_message.to_json)
    expect(valid).to be_truthy
  end

  it "should invalidate a bad message" do
    valid = JSON::Validator.validate(MessageValidator::CogValidator.schema, bad_message.to_json)
    expect(valid).to be_falsey
  end
end
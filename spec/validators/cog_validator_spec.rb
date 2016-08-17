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
    }.to_json
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
    }.to_json
  end

  it "should get type 'Cog' from MessageValidator" do
    message = JSON.parse(good_message)
    message.deep_transform_keys!(&:underscore).symbolize_keys!
    type = MessageValidator.get_message_type(message)
    expect(type).to eq('Cog')
  end

  it "should validate a good message" do
    message = JSON.parse(good_message)
    valid = MessageValidator::CogValidator.new.from_json(message.to_json).valid?
    expect(valid).to be_truthy
  end

  it "should invalidate a bad message" do
    message = JSON.parse(bad_message)
    valid = MessageValidator::CogValidator.new.from_json(message.to_json).valid?
    expect(valid).to be_falsey
  end

  it "should return a valid message when error" do
    message = JSON.parse(bad_message)
    message_validator = MessageValidator::CogValidator.new.from_json(message.to_json)
    expect(message_validator.valid?).to be_falsey
    expect(message_validator.errors.messages).not_to be_empty
    expect(message_validator.errors.messages.to_s).to include("can't be blank")
  end

end
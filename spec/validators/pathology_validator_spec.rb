require 'rails_helper'

describe 'PathologyValidator behavior' do

  let(:good_message) do
    {
        "patient_id":"3344",
        "surgical_event_id":"3344-bsn",
        "reported_date":"2015-12-12T12:13:09.071-05:00",
        "status":"Y",
        "message":"PATHOLOGY_CONFIRMATION"
    }
  end

  let(:bad_message) do
    {
        "patient_id":"3344",
        "surgical_event_id":"3344-bsn",
        "status":"Y",
        "message":"PATHOLOGY_CONFIRMATION"
    }
  end

  it "should get type 'Pathology' from MessageValidator" do
    type = MessageValidator.get_message_type(good_message.to_json)
    expect(type).to eq('Pathology')
  end

  it "should validate a good message" do
    valid = JSON::Validator.validate(MessageValidator::PathologyValidator.schema, good_message.to_json)
    expect(valid).to be_truthy
  end

  it "should invalidate a bad message" do
    valid = JSON::Validator.validate(MessageValidator::PathologyValidator.schema, bad_message.to_json)
    expect(valid).to be_falsey
  end
end
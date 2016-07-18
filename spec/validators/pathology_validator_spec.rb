require 'rails_helper'

describe 'PathologyValidator behavior' do

  let(:good_message) do
    {
        "patient_id":"3344",
        "surgical_event_id":"3344-bsn",
        "reported_date":"2015-12-12T12:13:09.071-05:00",
        "status":"Y",
        "message":"PATHOLOGY_CONFIRMATION"
    }.to_json
  end

  let(:bad_message) do
    {
        "patient_id":"3344",
        "surgical_event_id":"3344-bsn",
        "status":"Y",
        "message":"PATHOLOGY_CONFIRMATION"
    }.to_json
  end

  it "should get type 'Pathology' from MessageValidator" do
    message = JSON.parse(good_message)
    message.deep_transform_keys!(&:underscore).symbolize_keys!
    type = MessageValidator.get_message_type(message)
    expect(type).to eq('Pathology')
  end

  it "should validate a good message" do
    message = JSON.parse(good_message)
    message.deep_transform_keys!(&:underscore).symbolize_keys!
    valid = JSON::Validator.validate(MessageValidator::PathologyValidator.schema, message)
    expect(valid).to be_truthy
  end

  it "should invalidate a bad message" do
    message = JSON.parse(bad_message)
    message.deep_transform_keys!(&:underscore).symbolize_keys!
    valid = JSON::Validator.validate(MessageValidator::PathologyValidator.schema, message)
    expect(valid).to be_falsey
  end
end
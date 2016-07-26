require 'rails_helper'

describe 'AssayValidator behavior' do

  let(:good_message) do
    {
        "patient_id":"3344",
        "study_id": "APEC1621",
        "surgical_event_id":"3344-bsn",
        "biomarker":"ICCPTEN",
        "reported_date":"2015-12-12T12:12:09.071-05:00",
        "ordered_date":"2015-12-12T12:11:09.071-05:00",
        "result":"POSITIVE"
    }.to_json
  end

  let(:bad_message) do
    {
        "patient_id":"3344",
        "study_id": "APEC1621",
        "surgical_event_id":"3344-bsn",
        "reported_date":"2015-12-12T12:12:09.071-05:00",
        "ordered_date":"2015-12-12T12:11:09.071-05:00",
        "result":"POSITIVE"
    }.to_json

  end

  it "should get type 'Assay' from MessageValidator" do
    message = JSON.parse(good_message)
    message.deep_transform_keys!(&:underscore).symbolize_keys!
    type = MessageValidator.get_message_type(message)
    expect(type).to eq('Assay')
  end

  it "should validate a good message" do
    message = JSON.parse(good_message)
    message.deep_transform_keys!(&:underscore).symbolize_keys!
    valid = JSON::Validator.validate(MessageValidator::AssayValidator.schema, message)
    expect(valid).to be_truthy
  end

  it "should invalidate a bad message" do
    message = JSON.parse(bad_message)
    message.deep_transform_keys!(&:underscore).symbolize_keys!
    valid = JSON::Validator.validate(MessageValidator::AssayValidator.schema, message)
    expect(valid).to be_falsey
  end
end
require 'rails_helper'

describe 'VariantReportStatusValidator' do

  let(:good_message) do
    {
        "patient_id": "3344",
        "analysis_id": "job1",
        "status": "CONFIRMED",
        "comment": "some comment",
        "comment_user": "rick"
    }.to_json
  end

  let(:bad_message) do
    {
        "patient_id": "3344",
        "analysis_id": "job1",
        "status": "PENDING",
        "comment": "some comment"
    }.to_json
  end

  it "should get type 'VariantReportStatus' from MessageValidator" do
    message = JSON.parse(good_message)
    message.deep_transform_keys!(&:underscore).symbolize_keys!
    type = MessageValidator.get_message_type(message)
    expect(type).to eq('VariantReportStatus')
  end

  it "should invalidate a bad message" do
    message_validation = MessageValidator::VariantReportStatusValidator.new.from_json(bad_message)
    expect(message_validation.valid?).to be_falsy
  end

  it "should validate a good message" do
    message_validation = MessageValidator::VariantReportStatusValidator.new.from_json(good_message)
    expect(message_validation.valid?).to be_truthy
  end
end
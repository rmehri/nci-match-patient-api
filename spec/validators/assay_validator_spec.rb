require 'rails_helper'

describe 'AssayValidator behavior' do

  let(:good_message) do
    {
        :patient_id => "3344",
        :study_id => "APEC1621SC",
        :surgical_event_id=>"3344-bsn",
        :case_number=> "case-3377",
        :type=> "RESULT",
        :biomarker=>"ICCPTENs",
        :reported_date=>"2015-12-12T12:12:09.071-05:00",
        :result=>"POSITIVE"
    }
  end

  let(:bad_message) do
    {
        :patient_id => "3344",
        :study_id => "APEC1621SC",
        :biomarker=>"ICCPTENs",
        :surgical_event_id => "3344-bsn",
        :reported_date => "2015-12-12T12:12:09.071-05:00",
        :result => "POSITIVE"
    }

  end

  it "should get type 'Assay' from MessageValidator" do
    type = MessageFactory.get_message_type(good_message)
    expect(type.class).to eq(AssayMessage)
  end

  it "should validate a good message" do
    type = MessageFactory.get_message_type(good_message)
    expect(type.valid?).to be_truthy
  end

  it "should invalidate a bad message" do
    type = MessageFactory.get_message_type(bad_message)
    expect(type.valid?).to be_falsy
  end

end
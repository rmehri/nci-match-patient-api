require 'rails_helper'

RSpec.describe PathologyMessage do

  let(:good_message) do
    {
        :patient_id => "3344",
        :study_id => "APEC1621SC",
        :surgical_event_id => "3344-bsn",
        :case_number => "case-3377",
        :type => "PATHOLOGY_STATUS",
        :reported_date => "2015-12-12T12:13:09.071-05:00",
        :status => "Y"
    }
  end

  let(:bad_message) do
    {
        :patient_id => "3344",
        :surgical_event_id => "3344-bsn",
        :type => "PATHOLOGY_STATUS",
        :status => "Y"
    }
  end

  it{expect(MessageFactory.get_message_type(good_message).class).to eq(PathologyMessage)}
  it{expect(MessageFactory.get_message_type(good_message).valid?).to be_truthy}
  it{expect(MessageFactory.get_message_type(bad_message).valid?).to be_falsey }

end
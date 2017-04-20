require 'rails_helper'

RSpec.describe VariantReportStatusMessage do

  let(:good_message) do
    {
        :patient_id => "3344",
        :analysis_id => "job1",
        :status => "CONFIRMED",
        :comment => "some comment",
        :comment_user => "rick"
    }
  end

  let(:bad_message) do
    {
        :patient_id => "3344",
        :analysis_id => "job1",
        :status => "PENDING",
        :comment => "some comment"
    }
  end

  it{expect(MessageFactory.get_message_type(good_message).class).to eq(VariantReportStatusMessage)}

  it{expect(MessageFactory.get_message_type(good_message).valid?).to be_truthy}

  it{expect(MessageFactory.get_message_type(bad_message).valid?).to be_falsey}

end
require 'rails_helper'


RSpec.describe VariantReportMessage do

  let(:good_message) do
    {
        :patient_id => "3344",
        :ion_reporter_id => "ABS",
        :molecular_id => "3366-msn",
        :analysis_id => "job1",
        :tsv_file_name => "Test.txt"
    }
  end

  let(:bad_message) do
    {
        :patient_id => "3344",
        :analysis_id => "job1",
        :tsv_file_name => "Test.txt"
    }
  end

  it{expect(MessageFactory.get_message_type(good_message).class).to eq(VariantReportMessage)}

  it{expect(MessageFactory.get_message_type(good_message).valid?).to be_truthy}

  it{expect(MessageFactory.get_message_type(bad_message).valid?).to be_falsey}


end
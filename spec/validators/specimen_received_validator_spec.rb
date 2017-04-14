require 'rails_helper'

describe 'SpecimenReceivedValidator behavior' do

  let(:good_message_blood) do
    {
        :header=> {
            :msg_guid => "5c64192f-8a25-4874-9db6-fd55c398822d",
            :msg_dttm => "2016-04-25T18:42:13+00:00"
        },
        :specimen_received=> {
            :study_id => "APEC1621SC",
            :patient_id => "3344",
            :type => "BLOOD",
            :collection_dt => "2016-04-25",
            :received_dttm => "2016-04-25T15:17:11+00:00"
        },
        :internal_use_only => {
            :stars_patient_id => "ABCXYZ",
            :stars_specimen_id => "ABCXYZ-0AK64L",
            :stars_specimen_type => "Blood Fresh",
            :received_dttm => "2016-04-25T15:17:11+00:00",
            :qc_dttm => "2016-04-25T16:21:34+00:00"
        }
    }
  end

  let(:good_message_tissue) do
    {
        :header => {
            :msg_guid => "ab6d8d37-caf2-4dbb-a360-0032c7a7a76c",
            :msg_dttm => "2016-04-25T18:42:13+00:00"
        },
        :specimen_received => {
            :patient_id => "3344",
            :study_id => "APEC1621SC",
            :surgical_event_id => "3344-bsn",
            :type => "TISSUE",
            :collection_dt => "2016-04-25",
            :received_dttm => "2016-04-25T16:17:11+00:00"
        },
        :internal_use_only => {
            :stars_patient_id => "ABCXYZ",
            :stars_specimen_id => "ABCXYZ-0AK64M",
            :stars_specimen_type => "Paraffin Block Primary",
            :received_ts => "2016-04-25T15:17:11+00:00",
            :qc_ts => "2016-04-25T16:21:34+00:00"
        }
    }
  end

  let(:bad_message_tissue_empty_id) do
    {
        :header => {
            :msg_guid => "ab6d8d37-caf2-4dbb-a360-0032c7a7a76c",
            :msg_dttm => "2016-04-25T18:42:13+00:00"
        },
        :specimen_received => {
            :patient_id => "3344",
            :study_id => "APEC1621SC",
            :surgical_event_id => "",
            :type => "TISSUE",
            :collection_dt => "2016-04-25",
            :received_dttm => "2016-04-25T16:17:11+00:00"
        },
        :internal_use_only => {
            :stars_patient_id => "ABCXYZ",
            :stars_specimen_id => "ABCXYZ-0AK64M",
            :stars_specimen_type => "Paraffin Block Primary",
            :received_ts => "2016-04-25T15:17:11+00:00",
            :qc_ts => "2016-04-25T16:21:34+00:00"
        }
    }
  end

  let(:bad_message_unknown_type) do
    {
        :header => {
            :msg_guid => "ab6d8d37-caf2-4dbb-a360-0032c7a7a76c",
            :msg_dttm => "2016-04-25T18:42:13+00:00"
        },
        :specimen_received => {
            :patient_id => "3344",
            :study_id => "APEC1621SC",
            :surgical_event_id => "3344-bsn",
            :type => "BAD_TYPE",
            :collection_dt => "2016-04-25",
            :received_dttm => "2016-04-25T16:17:11+00:00"
        },
        :internal_use_only => {
            :stars_patient_id => "ABCXYZ",
            :stars_specimen_id => "ABCXYZ-0AK64M",
            :stars_specimen_type => "Paraffin Block Primary",
            :received_ts => "2016-04-25T15:17:11+00:00",
            :qc_ts => "2016-04-25T16:21:34+00:00"
        }
    }
  end

  it{expect(MessageFactory.get_message_type(good_message_blood).class).to eq(SpecimenReceivedMessage)}

  it{expect(MessageFactory.get_message_type(good_message_blood).valid?).to be_truthy}

  it{expect(MessageFactory.get_message_type(good_message_tissue).valid?).to be_truthy}

  it{expect(MessageFactory.get_message_type(bad_message_unknown_type).valid?).to be_falsey}

  let(:test_case) { MessageFactory.get_message_type(bad_message_tissue_empty_id) }
  it 'return valid fail message' do
    expect(test_case.valid?).to be_falsey
    expect(test_case.errors.messages.to_s).to include("can't be blank")
  end

end
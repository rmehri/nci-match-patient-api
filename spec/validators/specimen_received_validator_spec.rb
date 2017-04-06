require 'rails_helper'

describe 'SpecimenReceivedValidator behavior' do

  let(:good_message_blood) do
    {
        "header"=> {
            "msg_guid"=> "5c64192f-8a25-4874-9db6-fd55c398822d",
            "msg_dttm"=> "2016-04-25T18:42:13+00:00"
        },
        "specimen_received"=> {
            "study_id"=> "APEC1621SC",
            "patient_id"=> "3344",
            "type"=> "BLOOD",
            "collection_dt"=> "2016-04-25",
            "received_dttm"=> "2016-04-25T15:17:11+00:00"
        },
        "internal_use_only"=> {
            "stars_patient_id"=> "ABCXYZ",
            "stars_specimen_id"=> "ABCXYZ-0AK64L",
            "stars_specimen_type"=> "Blood Fresh",
            "received_dttm"=> "2016-04-25T15:17:11+00:00",
            "qc_dttm"=> "2016-04-25T16:21:34+00:00"
        }
    }.to_json
  end

  let(:good_message_tissue) do
    {
        "header"=> {
            "msg_guid"=> "ab6d8d37-caf2-4dbb-a360-0032c7a7a76c",
            "msg_dttm"=> "2016-04-25T18:42:13+00:00"
        },
        "specimen_received"=> {
            "patient_id"=> "3344",
            "study_id"=> "APEC1621SC",
            "surgical_event_id"=> "3344-bsn",
            "type"=> "TISSUE",
            "collection_dt"=> "2016-04-25",

            "received_dttm"=> "2016-04-25T16:17:11+00:00"
        },
        "internal_use_only"=> {
            "stars_patient_id"=> "ABCXYZ",
            "stars_specimen_id"=> "ABCXYZ-0AK64M",
            "stars_specimen_type"=> "Paraffin Block Primary",
            "received_ts"=> "2016-04-25T15:17:11+00:00",
            "qc_ts"=> "2016-04-25T16:21:34+00:00"
        }
    }.to_json
  end

  let(:bad_message_tissue_empty_id) do
    {
        "header"=> {
            "msg_guid"=> "ab6d8d37-caf2-4dbb-a360-0032c7a7a76c",
            "msg_dttm"=> "2016-04-25T18:42:13+00:00"
        },
        "specimen_received"=> {
            "patient_id"=> "3344",
            "study_id"=> "APEC1621SC",
            "surgical_event_id"=> "",
            "type"=> "TISSUE",
            "collection_dt"=> "2016-04-25",

            "received_dttm"=> "2016-04-25T16:17:11+00:00"
        },
        "internal_use_only"=> {
            "stars_patient_id"=> "ABCXYZ",
            "stars_specimen_id"=> "ABCXYZ-0AK64M",
            "stars_specimen_type"=> "Paraffin Block Primary",
            "received_ts"=> "2016-04-25T15:17:11+00:00",
            "qc_ts"=> "2016-04-25T16:21:34+00:00"
        }
    }.to_json
  end

  let(:bad_message_unknown_type) do
    {
        "header"=> {
            "msg_guid"=> "ab6d8d37-caf2-4dbb-a360-0032c7a7a76c",
            "msg_dttm"=> "2016-04-25T18:42:13+00:00"
        },
        "specimen_received"=> {
            "patient_id"=> "3344",
            "study_id"=> "APEC1621SC",
            "surgical_event_id"=> "3344-bsn",
            "type"=> "BAD_TYPE",
            "collection_dt"=> "2016-04-25",

            "received_dttm"=> "2016-04-25T16:17:11+00:00"
        },
        "internal_use_only"=> {
            "stars_patient_id"=> "ABCXYZ",
            "stars_specimen_id"=> "ABCXYZ-0AK64M",
            "stars_specimen_type"=> "Paraffin Block Primary",
            "received_ts"=> "2016-04-25T15:17:11+00:00",
            "qc_ts"=> "2016-04-25T16:21:34+00:00"
        }
    }.to_json
  end

  it "should get type 'SpecimenReceived' from MessageValidator" do
    message = JSON.parse(good_message_blood)
    message.deep_transform_keys!(&:underscore).symbolize_keys!
    type = MessageValidator.get_message_type(message)
    expect(type).to eq('SpecimenReceived')
  end

  it "should validate a good blood message" do
    message = JSON.parse(good_message_blood)
    message_validator = MessageValidator::SpecimenReceivedValidator.new.from_json(message.to_json)
    expect(message_validator.valid?).to be_truthy
  end

  it "should validate a good tissue message" do
    message = JSON.parse(good_message_tissue)
    valid = MessageValidator::SpecimenReceivedValidator.new.from_json(message.to_json).valid?
    expect(valid).to be_truthy
  end

  it "should invalidate a bad message" do
    message = JSON.parse(bad_message_unknown_type)
    valid = MessageValidator::SpecimenReceivedValidator.new.from_json(message.to_json).valid?
    expect(valid).to be_falsey
  end

  it "should invalidate a bad tissue message with empty surgical event id" do
    message = JSON.parse(bad_message_tissue_empty_id)
    message_validator = MessageValidator::SpecimenReceivedValidator.new.from_json(message.to_json)
    expect(message_validator.valid?).to be_falsey
    expect(message_validator.errors.messages.to_s).to include("can't be blank")
  end
end
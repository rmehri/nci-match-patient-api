require 'rails_helper'

describe 'SpecimenShippedValidator behavior' do

  let(:good_message_blood) do
    {
        "header"=> {
            "msg_guid"=> "3037ddec-0081-4e22-8448-721ab4ad76b4",
            "msg_dttm"=> "2016-05-01T19:42:13+00:00"
        },
        "specimen_shipped"=> {
            "study_id"=> "APEC1621",
            "patient_id"=> "3344",
            "type"=> "BLOOD_DNA",
            "molecular_id"=> "3344-bsn-msn",

            "carrier"=> "Federal Express",
            "tracking_id"=> "7956 4568 1235",
            "shipped_dttm"=> "2016-05-01T19:42:13+00:00",
            "destination"=> "Boston",

            "internal_use_only"=> {
                "stars_patient_id"=> "ABCXYZ",
                "stars_specimen_id_cdna"=> "ABCXYZ-0BJ64F",
                "stars_specimen_id_dna"=> "ABCXYZ-0BJ64B"
            }
        }
    }.to_json
  end

  let(:good_message_tissue) do
    {
        "header"=> {
            "msg_guid"=> "3037ddec-0081-4e22-8448-721ab4ad76b4",
            "msg_dttm"=> "2016-05-01T19:42:13+00:00"
        },
        "specimen_shipped"=> {
            "study_id"=> "APEC1621",
            "patient_id"=> "3344",
            "type"=> "TISSUE_DNA_AND_CDNA",

            "surgical_event_id"=> "3344-bsn",
            "molecular_id"=> "3344-bsn-msn",

            "molecular_dna_id"=> "00012D",
            "molecular_cdna_id"=> "00012C",

            "carrier"=> "Federal Express",
            "tracking_id"=> "7956 4568 1235",
            "shipped_dttm"=> "2016-05-01T19:42:13+00:00",
            "destination"=> "Boston",

            "internal_use_only"=> {
                "stars_patient_id"=> "ABCXYZ",
                "stars_specimen_id_cdna"=> "ABCXYZ-0BJ64F",
                "stars_specimen_id_dna"=> "ABCXYZ-0BJ64B"
            }
        }
    }.to_json
  end

  let(:bad_message_unknown_type) do
    {
        "header"=> {
            "msg_guid"=> "3037ddec-0081-4e22-8448-721ab4ad76b4",
            "msg_dttm"=> "2016-05-01T19:42:13+00:00"
        },
        "specimen_shipped"=> {
            "study_id"=> "APEC1621",
            "patient_id"=> "3344",
            "type"=> "TISSUE_BAD_TYPE",

            "surgical_event_id"=> "3344-bsn",
            "molecular_id"=> "3344-bsn-msn",

            "molecular_dna_id"=> "00012D",
            "molecular_cdna_id"=> "00012C",

            "carrier"=> "Federal Express",
            "tracking_id"=> "7956 4568 1235",
            "shipped_dttm"=> "2016-05-01T19:42:13+00:00",

            "internal_use_only"=> {
                "stars_patient_id"=> "ABCXYZ",
                "stars_specimen_id_cdna"=> "ABCXYZ-0BJ64F",
                "stars_specimen_id_dna"=> "ABCXYZ-0BJ64B"
            }
        }
    }.to_json
  end

  it "should get type 'SpecimenShipped' from MessageValidator" do
    message = JSON.parse(good_message_blood)
    message.deep_transform_keys!(&:underscore).symbolize_keys!
    type = MessageValidator.get_message_type(message)
    expect(type).to eq('SpecimenShipped')
  end

  it "should validate a good blood message" do
    message = JSON.parse(good_message_blood)
    valid = MessageValidator::SpecimenShippedValidator.new.from_json(message.to_json).valid?
    expect(valid).to be_truthy
  end

  it "should validate a good tissue message" do
    message = JSON.parse(good_message_tissue)
    valid = MessageValidator::SpecimenShippedValidator.new.from_json(message.to_json).valid?
    expect(valid).to be_truthy
  end

  it "should invalidate a bad message" do
    message = JSON.parse(bad_message_unknown_type)
    message_validator = MessageValidator::SpecimenShippedValidator.new.from_json(message.to_json)
    expect(message_validator.valid?).to be_falsey
    expect(message_validator.errors.messages.to_s).to include("is not a support type")
    expect(message_validator.errors.messages.to_s).to include("can't be blank")
  end
end
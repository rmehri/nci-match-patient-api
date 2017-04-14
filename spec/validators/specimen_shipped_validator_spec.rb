require 'rails_helper'

describe 'SpecimenShippedValidator behavior' do

  let(:good_message_blood) do
    {
        :header => {
            :msg_guid => "3037ddec-0081-4e22-8448-721ab4ad76b4",
            :msg_dttm => "2016-05-01T19:42:13+00:00"
        },
        :specimen_shipped => {
            :study_id => "APEC1621SC",
            :patient_id => "3344",
            :type => "BLOOD_DNA",
            :molecular_id => "3344-bsn-msn",
            :carrier => "Federal Express",
            :tracking_id => "7956 4568 1235",
            :shipped_dttm => "2016-05-01T19:42:13+00:00",
            :destination => "MDA"
        },
        :internal_use_only => {
            :stars_patient_id => "ABCXYZ",
            :stars_specimen_id_cdna => "ABCXYZ-0BJ64F",
            :stars_specimen_id_dna => "ABCXYZ-0BJ64B"
        }
    }
  end

  let(:good_message_slide) do
    {
        :header => {
            :msg_guid => "3037ddec-0081-4e22-8448-721ab4ad76b4",
            :msg_dttm => "2016-05-01T19:42:13+00:00"
        },
        :specimen_shipped => {
            :study_id => "APEC1621SC",
            :patient_id => "3344",
            :type => "SLIDE",
            :molecular_id => "3344-bsn-msn",
            :carrier => "Federal Express",
            :tracking_id => "7956 4568 1235",
            :shipped_dttm => "2016-05-01T19:42:13+00:00",
            :destination => "MDA",
            :surgical_event_id => "3344-bsn-msn",
            :slide_barcode => "1231453826",
        },
        :internal_use_only => {
            :stars_patient_id => "ABCXYZ",
            :stars_specimen_id_cdna => "ABCXYZ-0BJ64F",
            :stars_specimen_id_dna => "ABCXYZ-0BJ64B"
        }
    }
  end

  let(:good_message_tissue) do
    {
        :header => {
            :msg_guid => "3037ddec-0081-4e22-8448-721ab4ad76b4",
            :msg_dttm => "2016-05-01T19:42:13+00:00"
        },
        :specimen_shipped => {
            :study_id => "APEC1621SC",
            :patient_id => "3344",
            :type => "TISSUE_DNA_AND_CDNA",

            :surgical_event_id => "3344-bsn",
            :molecular_id => "3344-bsn-msn",
            :carrier => "Federal Express",
            :tracking_id => "7956 4568 1235",
            :shipped_dttm => "2016-05-01T19:42:13+00:00",
            :destination => "MoCha"
        },
        :internal_use_only => {
            :stars_patient_id => "ABCXYZ",
            :stars_specimen_id_cdna => "ABCXYZ-0BJ64F",
            :stars_specimen_id_dna => "ABCXYZ-0BJ64B"
        }
    }
  end

  let(:bad_message_unknown_type) do
    {
        :header => {
            :msg_guid => "3037ddec-0081-4e22-8448-721ab4ad76b4",
            :msg_dttm => "2016-05-01T19:42:13+00:00"
        },
        :specimen_shipped => {
            :study_id => "APEC1621SC",
            :patient_id => "3344",
            :type => "TISSUE_BAD_TYPE",
            :surgical_event_id => "3344-bsn",
            :molecular_id => "3344-bsn-msn",
            :molecular_dna_id => "00012D",
            :molecular_cdna_id => "00012C",
            :carrier => "Federal Express",
            :tracking_id => "7956 4568 1235",
            :shipped_dttm => "2016-05-01T19:42:13+00:00"
        },
        :internal_use_only => {
            :stars_patient_id => "ABCXYZ",
            :stars_specimen_id_cdna => "ABCXYZ-0BJ64F",
            :stars_specimen_id_dna => "ABCXYZ-0BJ64B"
        }
    }
  end

  it{expect(MessageFactory.get_message_type(good_message_blood).class).to eq(SpecimenShippedMessage)}

  it{expect(MessageFactory.get_message_type(good_message_blood).valid?).to be_truthy}

  it{expect(MessageFactory.get_message_type(good_message_tissue).valid?).to be_truthy}
  it{expect(MessageFactory.get_message_type(good_message_slide).valid?).to be_truthy}

  it{expect(MessageFactory.get_message_type(bad_message_unknown_type).valid?).to be_falsey}

  let(:test_case) { MessageFactory.get_message_type(bad_message_unknown_type) }
  it 'return valid fail message' do
    expect(test_case.valid?).to be_falsey
    expect(test_case.errors.messages.to_s).to include("can't be blank")
    expect(test_case.errors.messages.to_s).to include("is not a support type")
  end

end
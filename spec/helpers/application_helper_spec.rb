describe ApplicationHelper do

  let (:cog_message) do
    {
        "header" => {
            "msg_guid" => "0f8fad5b-d9cb-469f-al65-80067728950e",
            "msg_dttm" => "2016-05-09T22:06:33+00:00"
        },
        "study_id" => "APEC1621",
        "patient_id" => "3366",
        "step_number" => "1.0",
        "status_date" => "2016-05-09T22:06:33+00:00",
        "status" => "REGISTRATION",
        "internal_use_only" => {
            "request_id" => "4-654321",
            "environment" => "4",
            "request" => "REGISTRATION for patient_id 2222"
        }
    }
  end
  it 'should replace patient id in cog message' do
    message = ApplicationHelper.replace_value_in_patient_message(cog_message, "patient_id", "6677")
    message.deep_symbolize_keys!
    expect(message[:patient_id]).to eq("6677")
  end

  let(:nch_message) do
    {
        "header" => {
            "msg_guid" => "ab6d8d37-caf2-4dbb-a360-0032c7a7a76c",
            "msg_dttm" => "2016-04-25T18:42:13+00:00"
        },
        "specimen_received" => {
            "patient_id" => "3366",
            "study_id" => "APEC1621",
            "surgical_event_id" => "3366-bsn",
            "type" => "TISSUE",
            "collection_dt" => "2016-09-11",

            "received_dttm" => "2016-05-11T16:17:11+00:00"
        },
        "internal_use_only" => {
            "stars_patient_id" => "ABCXYZ",
            "stars_specimen_id" => "ABCXYZ-0AK64M",
            "stars_specimen_type" => "Paraffin Block Primary",
            "received_ts" => "2016-04-25T15:17:11+00:00",
            "qc_ts" => "2016-04-25T16:21:34+00:00"
        }
    }
  end
  it 'should replace patient id in nch message' do
    message = ApplicationHelper.replace_value_in_patient_message(nch_message, "patient_id", "6677")
    message.deep_symbolize_keys!
    expect(message[:specimen_received][:patient_id]).to eq("6677")
  end

  let(:no_patient_id_message) do
    {
        "header" => {
            "msg_guid" => "ab6d8d37-caf2-4dbb-a360-0032c7a7a76c",
            "msg_dttm" => "2016-04-25T18:42:13+00:00"
        },
        "specimen_received" => {
            "study_id" => "APEC1621",
            "surgical_event_id" => "3366-bsn",
            "type" => "TISSUE",
            "collection_dt" => "2016-09-11",

            "received_dttm" => "2016-05-11T16:17:11+00:00"
        },
        "internal_use_only" => {
            "stars_patient_id" => "ABCXYZ",
            "stars_specimen_id" => "ABCXYZ-0AK64M",
            "stars_specimen_type" => "Paraffin Block Primary",
            "received_ts" => "2016-04-25T15:17:11+00:00",
            "qc_ts" => "2016-04-25T16:21:34+00:00"
        }
    }
  end
  it 'should not throw error in a message that does not have a patient id' do
    message = ApplicationHelper.replace_value_in_patient_message(no_patient_id_message, "patient_id", "6677")
    message.deep_symbolize_keys!
    expect(message[:specimen_received][:patient_id]).to be_nil
  end
end
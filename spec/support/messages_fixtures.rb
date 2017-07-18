SpecimenReceivedMessage # ask rails devs why is this here
class SpecimenReceivedMessage

  VALID_SAMPLE = {
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
  }.deep_stringify_keys

  STILL_VALID_SAMPLE = {
    :header=> {
        # :msg_guid => "5c64192f-8a25-4874-9db6-fd55c398822d",
        # :msg_dttm => "2016-04-25T18:42:13+00:00"
        a: 1
    },
    :specimen_received=> {
        :study_id => "APEC1621SC",
        :patient_id => "3344",
        :type => "BLOOD",
        :collection_dt => "2016-04-25",
        :received_dttm => "2016-04-25T15:17:11+00:00"
    },
    :internal_use_only => {
        # :stars_patient_id => "ABCXYZ",
        # :stars_specimen_id => "ABCXYZ-0AK64L",
        # :stars_specimen_type => "Blood Fresh",
        # :received_dttm => "2016-04-25T15:17:11+00:00",
        # :qc_dttm => "2016-04-25T16:21:34+00:00"
        b: 2
    }
  }.deep_stringify_keys

  INVALID_SAMPLE = VALID_SAMPLE.except('header')
end


SpecimenShippedMessage
class SpecimenShippedMessage

  VALID_SAMPLE = {
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
  }.deep_stringify_keys

  INVALID_SAMPLE = VALID_SAMPLE.except('header')
end


AssayMessage
class AssayMessage

  VALID_SAMPLE = {
    :patient_id => "3344",
    :study_id => "APEC1621SC",
    :surgical_event_id=>"3344-bsn",
    :case_number=> "case-3377",
    :type=> "RESULT",
    :biomarker=>"ICCPTENs",
    :reported_date=>"2015-12-12T12:12:09.071-05:00",
    :result=>"POSITIVE"
  }.deep_stringify_keys

  INVALID_SAMPLE = VALID_SAMPLE.except('case_number', 'type')
end

VariantReportMessage
class VariantReportMessage
  VALID_SAMPLE = {
    :patient_id => "3344",
    :ion_reporter_id => "ABS",
    :molecular_id => "3366-msn",
    :analysis_id => "job1",
    :tsv_file_name => "Test.txt"
  }.deep_stringify_keys

  INVALID_SAMPLE = VALID_SAMPLE.except('ion_reporter_id', 'molecular_id')
  INVALID_SAMPLE_WITHOUT_PATIENT_ID = VALID_SAMPLE.except('patient_id')
end


CogMessage
class CogMessage
  VALID_REGISTRATION_SAMPLE = {
    header: {
        msg_guid: "0f8fad5b-d9cb-469f-al65-80067728950e",
        msg_dttm: "2016-05-09T22:06:33+00:00"
    },
    study_id: "APEC1621SC",
    patient_id: "3366",
    step_number: "1.0",
    status_date: "2016-05-09T22:06:33+00:00",
    status: "REGISTRATION",
    internal_use_only: {
        request_id: "4-654321",
        environment: "4",
        request: "REGISTRATION for patient_id 2222"
    }
  }.deep_stringify_keys

  INVALID_REGISTRATION_SAMPLE = VALID_REGISTRATION_SAMPLE.except('patient_id')
end

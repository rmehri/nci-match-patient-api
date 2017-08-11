class SpecimenReceivedFixture

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

  # TODO: extend validator to cover this
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

class SpecimenShippedFixture

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

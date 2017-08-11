class AssayFixture

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

  INVALID_SAMPLE_WITH_END_DATE_IN_PAST = {
    patient_id: "3366",
    study_id: "APEC1621SC",
    surgical_event_id:"3366-bsn",
    case_number: "case-3366",
    type: "RESULT",
    biomarker:"ICCBRG1s_in_past",
    reported_date:"2016-09-15T13:12:09.071-05:00",
    result:"POSITIVE"
  }.deep_stringify_keys
end

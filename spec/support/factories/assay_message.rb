FactoryGirl.define do
  factory :assay_message, class: NciMatchPatientModels::Specimen do
    [
      {
        "result" => "NEGATIVE",
        "case_number" => "case-3366",
        "biomarker" => "ICCPTENs",
        "result_date" => "2016-09-15T13:12:09.071-05:00",
        "patient_id" => "3366",
        "surgical_event_id" => "3366-bsn-1"
      },
      {
        "result" => "POSITIVE",
        "case_number" => "case-3366",
        "biomarker" => "ICCBRG1s",
        "result_date" => "2016-09-16T12:12:09.071-05:00",
        "patient_id" => "3366",
        "surgical_event_id" => "3366-bsn-1"
      }
    ]
  end
end
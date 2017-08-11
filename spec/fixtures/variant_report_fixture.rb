class VariantReportFixture
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

class CogFixture

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

  VALID_REQUEST_ASSIGNMENT_SAMPLE = {
    header: {
      msg_guid: "0f8fad5b-d9cb-469f-a165-80067728950e",
      msg_dttm: "2016-05-09T22:06:33+00:00"
    },
    study_id: "APEC1621SC",
    patient_id: "3366",
    step_number: "2.0",
    status: "REQUEST_ASSIGNMENT",
    status_date: "2016-05-10T22:05:33+00:00",
    message: "Physician determines it is not in the patient’s best interest.",
    internal_use_only: {
      request_id: "4-654400",
      environment: "5",
      request: "REQUEST_ASSIGNMENT for patient_id 1111",
      treatment_id: "APEC1621-A"
    }
  }.deep_stringify_keys

  VALID_ON_TREATMENT_ARM_SAMPLE = {
    header: {
      msg_guid: "0f8fad5b-d9cb-469f-a165-80067728950e",
      msg_dttm: "2016-05-09T22:06:33+00:00"
    },
    study_id: "APEC1621SC",
    patient_id: "3366",
    step_number: "1.1",
    treatment_arm_id: "APEC1621-A",
    stratum_id: "100",
    status_date: "2017-01-29T17:52:18+00:00",
    status: "ON_TREATMENT_ARM",
    message: "test message",
    internal_use_only: {
      request_id: "4-654400",
      environment: "5",
      request: "ON_TREATMENT_ARM for patient_id 00001",
      treatment_id: "APEC1621-A"
    }
  }.deep_stringify_keys

end

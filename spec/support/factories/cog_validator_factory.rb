# FactoryGirl for CogValidator

FactoryGirl.define do
  factory :good_message_registration, class: MessageValidator::CogValidator do
    header [
        {
            'msg_guid' => '0f8fad5b-d9cb-469f-al65-80067728950e',
            'msg_dttm' => '2016-05-09T22:06:33+00:00'
        }
           ]
    study_id  'APEC1621SC'
    patient_id '2222'
    step_number '1.0'
    status_date '2016-05-09T22:06:33+00:00'
    status 'REGISTRATION'
    internal_use_only [
        {
            "request_id"=> "4-654321",
            "environment"=> "4",
            "request"=> "REGISTRATION for patient_id 2222"
        }
                      ]
  end

  factory :bad_message_registration, class: MessageValidator::CogValidator do
    header [
               {
                   'msg_guid' => '0f8fad5b-d9cb-469f-al65-80067728950e',
                   'msg_dttm' => '2016-05-09T22:06:33+00:00'
               }
           ]
    study_id  'APEC1621SC'
    step_number '1.0'
    status_date '2016-05-09T22:06:33+00:00'
    status 'REGISTRATION'
    internal_use_only [
                          {
                              "request_id"=> "4-654321",
                              "environment"=> "4",
                              "request"=> "REGISTRATION for patient_id 2222"
                          }
                      ]

  end


  factory :good_message_on_treatment_arm, class: MessageValidator::CogValidator do
    header [
               {
                   'msg_guid' => '0f8fad5b-d9cb-469f-al65-80067728950e',
                   'msg_dttm' => '2016-05-09T22:06:33+00:00'
               }
           ]
    treatment_arm_id '12345'
    stratum_id '123456'
    study_id  'APEC1621SC'
    patient_id '2222'
    step_number '1.0'
    status_date '2016-05-09T22:06:33+00:00'
    status 'ON_TREATMENT_ARM'
    internal_use_only [
                          {
                              "request_id"=> "4-654321",
                              "environment"=> "4",
                              "request"=> "ON_TREATMENT_ARM for patient_id 2222"
                          }
                      ]
  end

  factory :bad_message_on_treatment_arm, class: MessageValidator::CogValidator do
    header [
               {
                   'msg_guid' => '0f8fad5b-d9cb-469f-al65-80067728950e',
                   'msg_dttm' => '2016-05-09T22:06:33+00:00'
               }
           ]
    study_id  'APEC1621SC'
    step_number '1.0'
    status_date '2016-05-09T22:06:33+00:00'
    status 'ON_TREATMENT_ARM'
    internal_use_only [
                          {
                              "request_id"=> "4-654321",
                              "environment"=> "4",
                              "request"=> "ON_TREATMENT_ARM for patient_id 2222"
                          }
                      ]

  end

  factory :good_message_off_study, class: MessageValidator::CogValidator do
    header [
               {
                   'msg_guid' => '0f8fad5b-d9cb-469f-al65-80067728950e',
                   'msg_dttm' => '2016-05-09T22:06:33+00:00'
               }
           ]
    study_id  'APEC1621SC'
    patient_id '2222'
    step_number '1.0'
    status_date '2016-05-09T22:06:33+00:00'
    status 'OFF_STUDY'
    internal_use_only [
                          {
                              "request_id"=> "4-654321",
                              "environment"=> "4",
                              "request"=> "OFF_STUDY for patient_id 2222"
                          }
                      ]
  end

  factory :bad_message_off_study, class: MessageValidator::CogValidator do
    header [
               {
                   'msg_guid' => '0f8fad5b-d9cb-469f-al65-80067728950e',
                   'msg_dttm' => '2016-05-09T22:06:33+00:00'
               }
           ]
    study_id  'APEC1621SC'
    step_number '1.0'
    status_date '2016-05-09T22:06:33+00:00'
    status 'OFF_STUDY'
    internal_use_only [
                          {
                              "request_id"=> "4-654321",
                              "environment"=> "4",
                              "request"=> "OFF_STUDY for patient_id 2222"
                          }
                      ]

  end

  factory :good_message_request_assignment, class: MessageValidator::CogValidator do
    header [
               {
                   'msg_guid' => '0f8fad5b-d9cb-469f-al65-80067728950e',
                   'msg_dttm' => '2016-05-09T22:06:33+00:00'
               }
           ]
    study_id  'APEC1621SC'
    patient_id '2222'
    step_number '1.0'
    status_date '2016-05-09T22:06:33+00:00'
    status 'REQUEST_ASSIGNMENT'
    internal_use_only [
                          {
                              "request_id"=> "4-654321",
                              "environment"=> "4",
                              "request"=> "REQUEST_ASSIGNMENT for patient_id 2222"
                          }
                      ]
    rebiopsy 'Y'
  end

  factory :bad_message_request_assignment, class: MessageValidator::CogValidator do
    header [
               {
                   'msg_guid' => '0f8fad5b-d9cb-469f-al65-80067728950e',
                   'msg_dttm' => '2016-05-09T22:06:33+00:00'
               }
           ]
    study_id  'APEC1621SC'
    step_number '1.0'
    status_date '2016-05-09T22:06:33+00:00'
    status 'REQUEST_ASSIGNMENT'
    internal_use_only [
                          {
                              "request_id"=> "4-654321",
                              "environment"=> "4",
                              "request"=> "REQUEST_ASSIGNMENT for patient_id 2222"
                          }
                      ]

  end

end

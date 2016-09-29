# require 'json'
#
# describe PatientUiModel do
#   let :getTestable do
#     model = PatientUiModel.new
#
#     model.patient_id           = 'PAT123'
#     model.registration_date    = '2016-05-09T22:06:33+00:00'
#     model.study_id             = 'APEC1621'
#     model.gender               = 'MALE'
#     model.ethnicity            = 'WHITE'
#     model.races                = ["WHITE", "HAWAIIAN"]
#     model.current_step_number  = "1.0"
#     model.current_assignment   = {"assignment_id" => "1234", "assignment_status" => "some_status"}
#     model.current_status       = "REGISTRATION"
#
#     model
#   end
#
#   it "can convert to json" do
#     testable = getTestable
#
#     json_string = testable.to_json
#
#     expect {
#       JSON.parse(json_string)
#     }.to_not raise_error
#
#   end
# end
describe PatientModelConverter do
  let(:dbModel) do
    model = Patient.new

    model.patient_id           = 'PAT123'
    model.registration_date    = '2016-05-09T22:06:33+00:00'
    model.study_id             = 'APEC1621'
    model.gender               = 'MALE'
    model.ethnicity            = 'WHITE'
    model.races                = ["WHITE", "HAWAIIAN"]
    model.current_step_number  = "1.0"
    model.current_assignment   = {"assignment_id" => "1234", "assignment_status" => "some_status"}
    model.current_status       = "REGISTRATION"
    model.disease              = {
        "name"              => "Invasive Breast Carcinoma",
        "ctep_category"     => "Breast Neoplasm",
        "ctep_sub_category" => "Breast Cancer - Invasive",
        "ctep_term"         => "Invasive Breast Carcinoma",
        "med_dra_code"      => "1000961"
    }
    
    model.prior_drugs          = ["Aspirin", "Motrin", "Vitamin C"]
    
    model.documents            = [
        {
            "name" => "Document 1",
            "uploadedDate" => "2016-05-09T22:06:33+00:00",
            "user" => "James Bond"
        },
        {
            "name" => "Document 2",
            "uploadedDate" => "2016-05-09T22:06:33+00:00",
            "user" => "James Bond"
        },
        {
            "name" => "X-File A23FSD34",
            "uploadedDate" => "2016-05-09T22:06:33+00:00",
            "user" => "Fox Mulder"
        }
    ]

    model
  end

  it "can convert DB model to UI model" do
  end
end
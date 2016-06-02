describe Convert do
  let(:db_model) do
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
    
    model.documents            = {"list" =>[
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
    ]}

    model
  end

  it "can convert DB model to UI model" do
    db = db_model

    ui = Convert::PatientDbModel.to_ui_model db

    expect(ui.patient_id).to eq "PAT123"
    expect(ui.gender).to eq "MALE"
    expect(ui.current_status).to eq "REGISTRATION"

    expect(ui.disease).to be_kind_of Hash
    expect(ui.disease["name"]).to eq "Invasive Breast Carcinoma"

    expect(ui.races).to be_kind_of Array
    expect(ui.races.size).to eq 2

    expect(ui.prior_drugs).to be_kind_of Array
    expect(ui.prior_drugs[0]).to eq "Aspirin"

    expect(ui.documents).to be_kind_of Hash
    expect(ui.documents["list"]).to be_kind_of Array
    expect(ui.documents["list"][0]["name"]).to eq "Document 1"

  end
end
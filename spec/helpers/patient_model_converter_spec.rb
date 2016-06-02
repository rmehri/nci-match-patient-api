describe Convert do
  let(:patient_db_model) do
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
  
  let(:biopsy_sel_db_model_list) do
    [1,2].map { |i|
      Biopsy.new(   
          :patient_id             => 'PAT123',
          :biopsy_sequence_number => 'MSN12345' + i.to_s,
          :biopsy_received_date   => '2016-05-09T22:06:33+00:00',
          :cg_collected_date   => '2016-06-09T22:06:33+00:00',
          :cg_id                  => 'GID098' + i.to_s,
          :study_id               => 'APEC1621' + i.to_s,
          :type                   => 'TYPE' + i.to_s,
      )
    }
  end

  it "can convert patient DB models" do
    dbm = patient_db_model

    uim = Convert::PatientDbModel.to_ui_model dbm, nil, nil, nil, nil, nil

    expect(uim.patient_id).to eq "PAT123"
    expect(uim.gender).to eq "MALE"
    expect(uim.current_status).to eq "REGISTRATION"

    expect(uim.disease).to be_kind_of Hash
    expect(uim.disease["name"]).to eq "Invasive Breast Carcinoma"

    expect(uim.races).to be_kind_of Array
    expect(uim.races.size).to eq 2

    expect(uim.prior_drugs).to be_kind_of Array
    expect(uim.prior_drugs[0]).to eq "Aspirin"

    expect(uim.documents).to be_kind_of Hash
    expect(uim.documents["list"]).to be_kind_of Array
    expect(uim.documents["list"][0]["name"]).to eq "Document 1"

  end

  it "can convert biopsy selector DB models" do
    patient_dbm = patient_db_model
    biopsies_dbm = biopsy_sel_db_model_list


    uim = Convert::PatientDbModel.to_ui_model patient_dbm, nil, biopsies_dbm, nil, nil, nil

    expect(uim).to_not eq nil

    expect(uim.biopsy_selectors).to_not eq nil
    expect(uim.biopsy_selectors[0]["text"]).to eq "TYPE1"
    expect(uim.biopsy_selectors[1]["biopsy_sequence_number"]).to eq "MSN123452"

  end

  it "can convert biopsy DB model" do
    patient_dbm = patient_db_model
    biopsies_dbm = biopsy_sel_db_model_list
    
    uim = Convert::PatientDbModel.to_ui_model patient_dbm, nil, biopsies_dbm, nil, nil, nil

    expect(uim).to_not eq nil

    expect(uim.biopsy).to_not eq nil
    expect(uim.biopsy["type"]).to eq "TYPE2"
    expect(uim.biopsy["biopsy_sequence_number"]).to eq "MSN123452"

  end

end
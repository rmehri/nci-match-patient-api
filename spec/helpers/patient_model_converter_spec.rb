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

  let(:events_db_model_list) do
    [1,2].map { |i|
      PatientEvent.new(
          :patient_id     => 'PAT123',
          :event_date     => '2016-05-09T22:06:33+00:00',
          :event_name     => 'Event Name ' + i.to_s,
          :event_type     => 'TYPE' + i.to_s,
          :event_message  => 'Message ' + i.to_s,
          :event_data     => { "status" => "Pending", "biopsy_sequence_number" => "B-987456" }
      )
    }
  end

  let(:biopsy_db_model_list) do
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

  let(:variant_report_db_model_list) do
    [1,2].map { |i|
      VariantReport.new(
          :cg_id                  => 'GID098' + i.to_s,
          :variant_report_received_date   => '2016-05-09T22:06:33+00:00',
          :patient_id             => 'PAT123',
          :molecular_id             => 'MSN123',
          :analysis_id             => 'AN123',
          :status             => 'PENDING',
          :confirmed_date   => '2016-05-09T22:06:33+00:00',
          :rejected_date   => '2016-06-09T22:06:33+00:00',
          :dna_bam_file_path => "http:\\\\blah.com\\dna_bam.data",
          :dna_bai_file_path => "http:\\\\blah.com\\dna_bai.data",
          :rna_bam_file_path => "http:\\\\blah.com\\rna_bam.data",
          :rna_bai_file_path => "http:\\\\blah.com\\rna_bai.data",
          :vcf_path          => "http:\\\\blah.com\\vcf.data"
      )
    }
  end

  let(:variant_db_model_list) do
    [1,2].map { |i|
      Variant.new(
        :molecular_id_analysis_id => "MSN123AN123",
        :variant_id => "COSM123" + i.to_s,
        :patient_id => "PAT123",
        :cg_id => "GID098" + "1",
        :variant_type => "single_nucleitide_variants",
        :status => "CONFIRMED",
        :confirmed_date => "",
        :rejected_date => "2016-06-09T22:06:33+00:00",
        :comment => "Don't need this",
        :gene_name => "gene",
        :chromosome => "chr3",
        :position => "12345",
        :oncomine_variant_class => "Hotspot",
        :exon => "10",
        :function => "missense",
        :reference => "A",
        :alternative => "C",
        :filter => "flt",
        :protein => "p.Glu6565Ala",
        :transcript => "NM_0456345",
        :hgvs => "c.234534>C",
        :read_depth => "648",
        :rare => "?",
        :allele_frequency => "0.0344",
        :flow_alternative_observation => "alt obs",
        :flow_reference_allele_observation => "alt allele",
        :reference_allele_observation => "ref allele",
        :inclusion => "inlc",
        :arm_specific => "arm spec"
      )
    }
  end

  it "works with patient DB models" do
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

  it "works with timeline DB models" do
    patient_dbm = patient_db_model
    events_dbm = events_db_model_list

    uim = Convert::PatientDbModel.to_ui_model patient_dbm, events_dbm, nil, nil, nil, nil

    expect(uim).to_not eq nil

    expect(uim.timeline).to_not eq nil
    expect(uim.timeline.size).to eq events_dbm.size
    expect(uim.timeline[0]["event_name"]).to eq "Event Name 1"
    expect(uim.timeline[1]["event_data"]["status"]).to eq "Pending"

  end

  it "works with biopsy selector DB models" do
    patient_dbm = patient_db_model
    biopsies_dbm = biopsy_db_model_list

    uim = Convert::PatientDbModel.to_ui_model patient_dbm, nil, biopsies_dbm, nil, nil, nil

    expect(uim).to_not eq nil

    expect(uim.biopsy_selectors).to_not eq nil
    expect(uim.biopsy_selectors.size).to eq biopsies_dbm.size
    expect(uim.biopsy_selectors[0]["text"]).to eq "TYPE1"
    expect(uim.biopsy_selectors[1]["biopsy_sequence_number"]).to eq "MSN123452"

  end

  it "works with biopsy DB model" do
    patient_dbm = patient_db_model
    biopsies_dbm = biopsy_db_model_list
    
    uim = Convert::PatientDbModel.to_ui_model patient_dbm, nil, biopsies_dbm, nil, nil, nil

    expect(uim).to_not eq nil

    expect(uim.biopsy).to_not eq nil
    expect(uim.biopsy["type"]).to eq "TYPE2"
    expect(uim.biopsy["biopsy_sequence_number"]).to eq "MSN123452"

  end

  it "works with variant report selector DB models" do
    patient_dbm = patient_db_model
    variant_reports_dbm = variant_report_db_model_list

    # p "variant_reports_dbm"
    # p variant_reports_dbm

    uim = Convert::PatientDbModel.to_ui_model patient_dbm, nil, nil, variant_reports_dbm, nil, nil

    expect(uim).to_not eq nil

    expect(uim.variant_report_selectors).to_not eq nil
    expect(uim.variant_report_selectors.size).to eq variant_reports_dbm.size
    expect(uim.variant_report_selectors[0]["text"]).to eq "GID0981"
    expect(uim.variant_report_selectors[1]["variant_report_received_date"]).to eq "2016-05-09T22:06:33+00:00"

  end

  it "works with variant report DB model" do
    patient_dbm = patient_db_model
    variant_reports_dbm = variant_report_db_model_list
    variants_dbm = variant_db_model_list

    uim = Convert::PatientDbModel.to_ui_model patient_dbm, nil, nil, variant_reports_dbm, variants_dbm, nil

    expect(uim).to_not eq nil

    expect(uim.variant_report).to_not eq nil

    expect(uim.variant_report["cg_id"]).to eq "GID0982"
    expect(uim.variant_report["analysis_id"]).to eq "AN123"

    expect(uim.variant_report["variants"]).to_not eq nil

    expect(uim.variant_report["variants"]["single_nucleitide_variants"]).to_not eq nil
    expect(uim.variant_report["variants"]["indels"]).to_not eq nil
    expect(uim.variant_report["variants"]["copyNumberVariants"]).to_not eq nil
    expect(uim.variant_report["variants"]["geneFusions"]).to_not eq nil

    expect(uim.variant_report["variants"]["single_nucleitide_variants"]).to be_kind_of Array

    # expect(uim.variant_report["variants"]["single_nucleitide_variants"][0]["gene_name"]).to eq "gene"

  end
end
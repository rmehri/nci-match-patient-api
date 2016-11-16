describe V1::SpecimenEventsController do

  it 'GET #show' do
    expect { get :show, :id => 1}.to raise_error(ActionController::UrlGenerationError)
  end
  it 'GET #index' do
    expect(:get => "api/v1/patients/1/specimen_events?surgical_event_id=msn_3344").to route_to(:controller => "v1/specimen_events",
                                                                        :action => "index",
                                                                        :patient_id => "1", :surgical_event_id => "msn_3344")
    expect(:get => "api/v1/patients/1/specimen_events").to route_to(:controller => "v1/specimen_events", :action => "index", :patient_id => "1")
  end

  it 'GET #index should return something' do
    get :index, :patient_id => "1234"
    expect(response).to have_http_status(200)
    expect(response.body).to eq("{\"tissue_specimens\":[]}")
  end

  it 'GET #index should return a proper json with data' do
    specimen = NciMatchPatientModels::Specimen.new
    specimen.patient_id = "3366"
    specimen.type = 'TISSUE'
    specimen.surgical_event_id = 'surg_123'
    allow(NciMatchPatientModels::Specimen).to receive(:scan).and_return([specimen])

    shipment = NciMatchPatientModels::Shipment.new
    shipment.patient_id = "3366"
    shipment.molecular_id = "mole_123"
    allow(NciMatchPatientModels::Shipment).to receive(:scan).and_return([shipment])

    variant_report = NciMatchPatientModels::VariantReport.new
    variant_report.patient_id = "3366"
    variant_report.variant_report_received_date = DateTime.current.getutc().to_s
    variant_report.molecular_id = "mole_123"
    variant_report.analysis_id = "ana_123"
    variant_report.ion_reporter_id = "ion_123"
    allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([variant_report])

    assignment = NciMatchPatientModels::Assignment.new
    assignment.patient_id = "3366"
    assignment.assignment_date = DateTime.current.getutc().to_s
    assignment.molecular_id = "mole_123"
    assignment.analysis_id = "ana_123"
    assignment.status = "PENDING"
    assignment.status_date = DateTime.current.getutc().to_s
    assignment.report_status = "NO_TA_FOUND"
    allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([assignment])

    file_set = [{:file_path_name => "bucket/folder/file.vcf",
     :public_url => "https://s3.aws.com",
     :file_size => 5,
     :last_modified => "2016-11-11"}]
    allow(Aws::S3::S3Reader).to receive(:get_file_set).and_return(file_set)

    get :index, :patient_id => "3366"
    expect(response).to have_http_status(200)

    events = JSON.parse(response.body).deep_symbolize_keys
    puts "=========== events: #{events}"
    expect(events[:tissue_specimens][0][:specimen_shipments][0][:analyses]).not_to be_nil
  end

  it 'GET #index with actual data TISSUE' do
    allow(NciMatchPatientModels::Specimen).to receive(:scan).and_return([{:surgical_event_id => "1234", :type => "TISSUE", :specimen_shipments => []}])
    allow(NciMatchPatientModels::Shipment).to receive(:scan).and_return([:molecular_id => "msn-1234"])
    allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([])
    get :index, :patient_id => "1234"
    expect(response).to have_http_status(200)
    expect(response.body).not_to be_blank
  end

  it 'GET #index with actual data BLOOD' do
    allow(NciMatchPatientModels::Specimen).to receive(:scan).and_return([{:surgical_event_id => "1234", :type => "BLOOD", :specimen_shipments => []}])
    allow(NciMatchPatientModels::Shipment).to receive(:scan).and_return([:molecular_id => "msn-1234"])
    allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([])
    get :index, :patient_id => "1234"
    expect(response).to have_http_status(200)
    expect(response.body).to include("specimen_shipments\":[]")
  end

  it 'POST #create' do
    expect { post :create, :id => 1}.to raise_error(ActionController::UrlGenerationError)
  end

  it '#update should throw an route error' do
    expect { patch :update, :id => 1}.to raise_error(ActionController::UrlGenerationError)
  end

  it '#delete should throw an route error' do
    expect { delete :destroy, :id => 1}.to raise_error(ActionController::UrlGenerationError)
  end

end
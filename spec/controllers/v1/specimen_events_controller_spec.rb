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
    expect(response.body).to eq("[]")
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
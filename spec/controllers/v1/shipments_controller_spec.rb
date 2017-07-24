describe V1::ShipmentsController do

  it 'GET #show' do
    expect(:get => "api/v1/patients/shipments/3344").to route_to(:controller => "v1/shipments", :action => "show", :id => "3344")
  end
  it 'GET #index' do
    expect(:get => "api/v1/patients/shipments?molecular_id=3366").to route_to(:controller => "v1/shipments",
                                                                        :action => "index",
                                                                        :molecular_id => "3366")
    expect(:get => "api/v1/patients/shipments").to route_to(:controller => "v1/shipments", :action => "index")
  end

  it 'GET #show will return something' do
    allow(NciMatchPatientModels::Shipment).to receive(:scan).and_return({})
    get :show, params: {id: '123_test'}
    expect(response.body).to eq("")
  end

  it 'POST #create' do
    expect { post :create, params: {id: 1}}.to raise_error(ActionController::UrlGenerationError)
  end

  it '#update should throw an route error' do
    expect { patch :update, params: {id: 1}}.to raise_error(ActionController::UrlGenerationError)
  end

  it '#delete should throw an route error' do
    expect { delete :destroy, params: {id: 1}}.to raise_error(ActionController::UrlGenerationError)
  end

end

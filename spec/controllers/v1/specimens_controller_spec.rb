describe V1::SpecimensController do

  it 'GET #show' do
    expect(:get => "api/v1/patients/3344/specimens/msn-3344").to route_to(:controller => "v1/specimens", :action => "show",
                                                                          :patient_id  => "3344",
                                                                          :id => "msn-3344")
  end

  it 'GET #index' do
    expect(:get => "api/v1/patients/3344/specimens?surgical_event_id=3344").to route_to(:controller => "v1/specimens",
                                                                                        :action => "index",
                                                                                        :patient_id  => "3344",
                                                                                        :surgical_event_id => "3344")
    expect(:get => "api/v1/patients/3344/specimens").to route_to(:controller => "v1/specimens",
                                                                 :action => "index", :patient_id  => "3344",)
  end

  it 'GET #show will return something' do
    allow(NciMatchPatientModels::Specimen).to receive(:scan).and_return({})
    get :show, params: {patient_id: '123_test', id: "msn-123"}
    expect(response.body).to eq("")
  end

  it 'GET #index will return something' do
    allow(NciMatchPatientModels::Specimen).to receive(:scan).and_return({})
    get :index, params: {patient_id: '123_test'}
    expect(response.body).to eq("[]")
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

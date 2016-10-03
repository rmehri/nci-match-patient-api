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
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
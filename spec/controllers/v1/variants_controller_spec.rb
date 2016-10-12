describe V1::VariantsController do

  it 'GET #show' do
    expect(:get => "api/v1/patients/variants/3344").to route_to(:controller => "v1/variants", :action => "show", :id => "3344")
  end

  it 'GET #index' do
    expect(:get => "api/v1/patients/variants?analysis_id=3344").to route_to(:controller => "v1/variants",
                                                                        :action => "index",
                                                                        :analysis_id => "3344")
    expect(:get => "api/v1/patients/variants").to route_to(:controller => "v1/variants", :action => "index")
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
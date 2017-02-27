describe V1::EventsController do

  it 'GET #show' do
    expect(:get => "api/v1/patients/events/3344").to route_to(:controller => "v1/events", :action => "show", :id => "3344")
  end

  it 'GET #index' do
    expect(:get => "api/v1/patients/events?entity_id=3344").to route_to(:controller => "v1/events",
                                                                        :action => "index",
                                                                        :entity_id => "3344")
    expect(:get => "api/v1/patients/events").to route_to(:controller => "v1/events", :action => "index")
  end


  it 'POST #create' do
    expect(post :create, :id => 1).to have_http_status(500)
  end

  it '#update should throw an route error' do
    expect { patch :update, :id => 1}.to raise_error(ActionController::UrlGenerationError)
  end

  it '#delete should throw an route error' do
    expect { delete :destroy, :id => 1}.to raise_error(ActionController::UrlGenerationError)
  end

  # describe "should build a valid query" do
  #
  #   it "contain the correct key" do
  #     controller.stub_const("params", {:id => "3344"})
  #     event_controller = V1::EventsController.new
  #     p event_controller.send(:events_params)
  #   end
  #
  # end

end
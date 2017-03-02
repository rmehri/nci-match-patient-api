describe V1::EventsController, :type => :controller do

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
    expect(:post => "api/v1/patients/events").to route_to(:controller => "v1/events", :action => "create")
  end

  it 'POST #create success' do
    allow(PatientProcessor).to receive(:run_service).and_return("test")
    post :create, '{"patient_id": "123", "molecular_id": "123-mol", "analysis_id": "123-ana", "surgical_event_id": "123-surg", "rna_file_name": "test.bam" }'
    expect(response.body).to include("test")
  end

  it 'POST #create success' do
    post :create, '{"entity_id": "123"}'
    expect(response.status).to eq(403)
  end

  it '#update should throw an route error' do
    expect { patch :update, params: {id: 1}}.to raise_error(ActionController::UrlGenerationError)
  end

  it '#delete should throw an route error' do
    expect { delete :destroy, params: {id: 1}}.to raise_error(ActionController::UrlGenerationError)
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
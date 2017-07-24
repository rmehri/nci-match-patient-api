describe V1::StatisticsController do

  it 'GET #statistics no data' do
    allow(NciMatchPatientModels::Patient).to receive(:find_by).and_return([])
    allow(NciMatchPatientModels::VariantReport).to receive(:find_by).and_return([])
    get :patient_statistics
    expect(response).to have_http_status(200)
    expect(response.body).not_to be_empty
  end

  # it 'GET #statistics with data' do
  #   allow(NciMatchPatientModels::Patient).to receive(:scan).and_return([{:patient_id => "test123" ,:current_status => "ON_TREATMENT_ARM", :current_assignment => {:selected_treatment_arm => {:treatment_arm_id => "random", :stratum_id => "123", :version => "2015"}}}])
  #   allow(NciMatchPatientModels::VariantReport).to receive(:find_by).and_return([{}])
  #   get :patient_statistics
  #   expect(response).to have_http_status(200)
  #   data = JSON.parse(response.body).deep_symbolize_keys
  #   expect(data[:number_of_patients]).to eq("1")
  #   expect(data[:number_of_patients_on_treatment_arm]).to eq("1")
  #   expect(data[:number_of_patients_with_confirmed_variant_report]).to eq("1")
  # end

  it 'GET #amois without data' do
    allow(NciMatchPatientModels::VariantReport).to receive(:find_by).and_return([])
    get :sequenced_and_confirmed_patients
    expect(response).to have_http_status(200)
    expect(response.body).not_to be_empty
  end

  it 'GET #amois with data' do
    allow(NciMatchPatientModels::VariantReport).to receive(:scan_and_find_by).and_return([{'total_confirmed_amois' => 0},
                                                                                 {'total_confirmed_amois' => 1},
                                                                                 {'total_confirmed_amois' => 2},
                                                                                 {'total_confirmed_amois' => 3},
                                                                                 {'total_confirmed_amois' => 4},
                                                                                 {'total_confirmed_amois' => 5}])
    get :sequenced_and_confirmed_patients
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)["amois"]).to eq([1, 1, 1, 1, 1, 1])
  end

  it 'GET #show' do
    expect { post :show, params: {id: 1}}.to raise_error(ActionController::UrlGenerationError)
  end
  it 'GET #index' do
    expect { get :index }.to raise_error(ActionController::UrlGenerationError)
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

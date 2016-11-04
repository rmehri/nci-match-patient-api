describe V1::AnalysisReportController do

  # it 'GET #statistics no data' do
  #   allow(NciMatchPatientModels::Patient).to receive(:find_by).and_return([])
  #   allow(NciMatchPatientModels::VariantReport).to receive(:find_by).and_return([])
  #   get :patient_statistics
  #   expect(response).to have_http_status(200)
  #   expect(response.body).not_to be_empty
  # end
  #
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
  #
  # it 'GET #amois without data' do
  #   allow(NciMatchPatientModels::VariantReport).to receive(:find_by).and_return([])
  #   get :sequenced_and_confirmed_patients
  #   expect(response).to have_http_status(200)
  #   expect(response.body).not_to be_empty
  # end

  it 'should return variant report with assignment' do
    patient = NciMatchPatientModels::Patient.new
    patient.patient_id = "3366"
    patient.registration_date = DateTime.current.getutc().to_s
    allow(NciMatchPatientModels::Patient).to receive(:query).and_return([patient])

    variant_report_hash = {:patient_id => "3366", :variant_report_type => "TISSUE", :analysis_id => "3366_job1"}

    variant1 = NciMatchPatientModels::Variant.new
    variant1.uuid = "random1"
    variant1.variant_type = "snp"
    variant1.amois = []
    variant1.confirmed = false
    variant1.molecular_id = "mo-1234"
    variant1.analysis_id = "an-1234"

    variant2 = NciMatchPatientModels::Variant.new
    variant2.uuid = "random2"
    variant2.variant_type = "fusion"
    variant2.amois = [{'treatment_id' => 'A', 'stratum_id' => '100', 'version' => '2016'}]
    variant2.confirmed = true
    variant2.molecular_id = "mo-1234"
    variant2.analysis_id = "an-1234"

    variant_report_hash[:snv_indels] = [variant1.to_h]
    variant_report_hash[:gene_fusions] = [variant2.to_h]

    get :analysis_view
    expect(response).to have_http_status(500)
  end

  it 'throws error because patient does not exist' do
    allow(NciMatchPatientModels::Patient).to receive(:query).and_return([])
    get :analysis_view
    expect(response).to have_http_status(500)
  end

  it 'GET #show' do
    expect { post :show, :id => 1}.to raise_error(ActionController::UrlGenerationError)
  end
  it 'GET #index' do
    expect { get :index }.to raise_error(ActionController::UrlGenerationError)
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
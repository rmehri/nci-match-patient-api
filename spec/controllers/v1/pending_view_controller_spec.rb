describe V1::PendingViewController do

  it 'should return a pending view with 1 pending variant report' do
    variant_report = NciMatchPatientModels::VariantReport.new
    variant_report.patient_id = "3366"
    variant_report.variant_report_received_date = DateTime.current.getutc().to_s
    variant_report.analysis_id = "an-1234"
    variant_report.molecular_id = "mo-1234"
    variant_report.ion_reporter_id = "ion-1234"
    variant_report.tsv_file_name = "4.tsv"
    variant_report.status = 'PENDING'
    variant_report.variant_report_type = 'TISSUE'
    allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([variant_report])

    allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([])
    get :pending_view
    expect(response).to have_http_status(200)

    pending_view = report = JSON.parse(response.body).deep_symbolize_keys
    expect(pending_view[:tissue_variant_reports].length).to eq(1)
    expect(pending_view[:assignment_reports].length).to eq(0)
  end

  it 'should return a pending view with 1 pending assignment report' do
    allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([])

    assignment = NciMatchPatientModels::Assignment.new
    assignment.patient_id = "3366"
    assignment.assignment_date = DateTime.current.getutc().to_s
    assignment.analysis_id = "an-1234"
    assignment.molecular_id = "mo-1234"
    assignment.status = 'PENDING'
    assignment.surgical_event_id = 'event_id'
    assignment.selected_treatment_arm = {:treatment_arm_id => 'A', :stratum_id => '1', :version => "2016"}
    allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([assignment])

    patient = NciMatchPatientModels::Patient.new
    patient.patient_id = "3366"
    patient.diseases = [{:disease_name => "cancer", :disease_id => '123'}]
    allow(NciMatchPatientModels::Patient).to receive(:query).and_return([patient])

    get :pending_view
    expect(response).to have_http_status(200)

    pending_view = report = JSON.parse(response.body).deep_symbolize_keys
    expect(pending_view[:tissue_variant_reports].length).to eq(0)
    expect(pending_view[:assignment_reports].length).to eq(1)
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
describe V1::AnalysisReportController do


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

    allow(NciMatchPatientModelExtensions::VariantReportExtension).to receive(:compose_variant_report).and_return(variant_report_hash)

    assignment = NciMatchPatientModels::Assignment.new
    assignment.patient_id = "3366"
    assignment.assignment_date = DateTime.current.getutc().to_s
    assignment.surgical_event_id = "sei-1234"
    assignment.analysis_id = "an-1234"
    allow(NciMatchPatientModels::Assignment).to receive(:query).and_return([assignment])

    specimen = NciMatchPatientModels::Specimen.new
    specimen.patient_id = "3366"
    specimen.collected_date = DateTime.current.getutc().to_s
    allow(NciMatchPatientModels::Specimen).to receive(:scan).and_return([specimen])

    get :show, params: {:patient_id => "3366", :id => "an-1234"}
    expect(response).to have_http_status(200)
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

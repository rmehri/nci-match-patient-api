describe V1::AnalysisReportController do

  it 'should return 404 because patient does not exist' do
    patient = NciMatchPatientModels::Patient.new
    patient.patient_id = "3366"
    patient.registration_date = DateTime.current.getutc().to_s
    allow(NciMatchPatientModels::Patient).to receive(:query).and_return([])
    get :analysis_view
    expect(response).to have_http_status(404)
  end

  it 'should return 404 because variant report does not exist' do
    patient = NciMatchPatientModels::Patient.new
    patient.patient_id = "3366"
    patient.registration_date = DateTime.current.getutc().to_s

    allow(NciMatchPatientModels::Patient).to receive(:query).and_return([patient])
    allow(NciMatchPatientModelExtensions::VariantReportExtension).to receive(:query).and_return(nil)

    get :analysis_view, :patient_id => "3366", :analysis_id => "1"
    expect(response).to have_http_status(500)
  end


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
    allow(NciMatchPatientModels::Assignment).to receive(:query).and_return([assignment])

    specimen = NciMatchPatientModels::Specimen.new
    specimen.patient_id = "3366"
    specimen.collected_date = DateTime.current.getutc().to_s
    allow(NciMatchPatientModels::Specimen).to receive(:scan).and_return([specimen])

    get :analysis_view, :patient_id => "3366", :analysis_id => "1"
    expect(response).to have_http_status(200)
  end

  it 'should return updated variant report with amois' do
    variant_report = NciMatchPatientModels::VariantReport.new
    variant_report.patient_id = "3366"
    variant_report.variant_report_received_date = DateTime.current.getutc().to_s
    variant_report.analysis_id = "an-1234"
    variant_report.molecular_id = "mo-1234"
    variant_report.ion_reporter_id = "ion-1234"
    variant_report.tsv_file_name = "4.tsv"
    allow(NciMatchPatientModels::VariantReport).to receive(:query).and_return([variant_report])

    report_from_rules = variant_report.to_h
    report_from_rules[:snv_indels] = [{:variant_type => "fusion", :molecular_id => "mo-1234", :analysis_id => "an-1234", :func_gene => "fusion_gene"}]
    report_from_rules[:gene_fusions] = [{:amois => {:treatment_arm_id => 'A', :stratum_id => '100', :version => "2016"},
                                         :variant_type => "fusion", :molecular_id => "mo-1234", :analysis_id => "an-1234", :chromosome => "chr17"}]

    updater = VariantReportUpdater.new
    allow(VariantReportUpdater).to receive(:new).and_return(updater)
    allow(updater).to receive(:updated_variant_report).and_return(report_from_rules.deep_symbolize_keys)

    variant1 = NciMatchPatientModels::Variant.new
    variant1.uuid = "random1"
    variant1.variant_type = "snp"
    variant1.amois = []
    variant1.confirmed = false
    variant1.molecular_id = "mo-1234"
    variant1.analysis_id = "an-1234"
    variant1.func_gene = "snp_gene"
    variant1.chromosome = "chr17"

    variant2 = NciMatchPatientModels::Variant.new
    variant2.uuid = "random2"
    variant2.variant_type = "fusion"
    variant2.amois = [{'treatment_id' => 'A', 'stratum_id' => '100', 'version' => '2016'}]
    variant2.confirmed = true
    variant2.molecular_id = "mo-1234"
    variant2.analysis_id = "an-1234"
    variant1.func_gene = "fusion_gene"
    variant1.chromosome = "chr1"

    allow(NciMatchPatientModels::Variant).to receive(:scan).and_return([variant2])

    get :amois_update, :patient_id => "3366", :analysis_id => "an-1234"
    expect(response).to have_http_status(200)

    report = JSON.parse(response.body).deep_symbolize_keys
    expect(report[:gene_fusions].length).to eq(1)
    expect(report[:gene_fusions][0][:uuid]).to eq("random2")

  end

  it 'throws error because patient does not exist' do
    allow(NciMatchPatientModels::Patient).to receive(:query).and_return([])
    get :analysis_view
    expect(response).to have_http_status(404)
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
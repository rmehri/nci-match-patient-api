# mock cache
module MemoryCache
  mattr_accessor :storage
  def self.memoize(*key_fragments, &block)
    # cache hit
    key = key_fragments.hash
    puts "Cache key: #{key}"

    cached_value = self.storage[key]
    return cached_value if cached_value

    # cache miss
    new_value = block.call
    self.storage[key] = new_value
  end
end
MemoryCache.storage = {}

describe V1::AnalysisReportAmoisController do
  it 'should return updated variant report with amois' do
    # patient
    patient = NciMatchPatientModels::Patient.new
    patient.patient_id        = "3366"
    patient.registration_date = "2016"
    allow(NciMatchPatientModels::Patient).to receive(:query).and_return([patient])

    # variant_report
    variant_report = NciMatchPatientModels::VariantReport.new
    variant_report.patient_id       = "3366"
    variant_report.analysis_id      = "an-1234"
    variant_report.molecular_id     = "mo-1234"
    variant_report.ion_reporter_id  = "ion-1234"
    variant_report.tsv_file_name    = "4.tsv"
    variant_report.variant_report_received_date = DateTime.current.getutc().to_s

    allow(NciMatchPatientModels::VariantReport).to receive(:query).and_return([variant_report])

    # rules report
    report_from_rules = variant_report.to_h
    report_from_rules[:snv_indels]    = [{:variant_type => "snp", :molecular_id => "mo-1234", :analysis_id => "an-1234", :func_gene => "fusion_gene"}]
    report_from_rules[:gene_fusions]  = [{:amois => {:treatment_arm_id => 'A', :stratum_id => '100', :version => "2016"},
                                         :variant_type => "fusion", :molecular_id => "mo-1234", :analysis_id => "an-1234", :chromosome => "chr1"}]
    allow(VariantReportUpdater).to receive(:updated_variant_report).and_return(report_from_rules.deep_symbolize_keys)

    # variant 1
    variant1 = NciMatchPatientModels::Variant.new
    variant1.uuid = "random1"
    variant1.variant_type = "snp"
    variant1.amois = []
    variant1.confirmed = false
    variant1.molecular_id = "mo-1234"
    variant1.analysis_id = "an-1234"
    variant1.func_gene = "snp_gene"
    variant1.chromosome = "chr17"

    # variant 2
    variant2 = NciMatchPatientModels::Variant.new
    variant2.uuid = "random2"
    variant2.variant_type = "fusion"
    variant2.amois = [{'treatment_id' => 'A', 'stratum_id' => '100', 'version' => '2016'}]
    variant2.confirmed = true
    variant2.molecular_id = "mo-1234"
    variant2.analysis_id = "an-1234"
    variant2.func_gene = "fusion_gene"
    variant2.chromosome = "chr1"
    allow(NciMatchPatientModels::Variant).to receive(:scan).and_return([variant2])

    allow(db_client).to receive(:put_item)

    # check cache storage before first call
    expect(MemoryCache.storage.size).to eq(0)

    # check expectations
    expect( get :show, params: {:patient_id => "3366", :id => "an-1234"}).to have_http_status(200)
    report = JSON.parse(response.body).deep_symbolize_keys
    expect(report[:gene_fusions].length).to eq(1)
    expect(report[:gene_fusions][0][:uuid]).to eq("random2")

    # check cache storage after first call
    expect(MemoryCache.storage.size).to eq(1)

    # check cache storage after second call
    get :show, params: {:patient_id => "3366", :id => "an-1234"}
    expect(MemoryCache.storage.size).to eq(2) # variant_report in memoize input is mutated so we have diffrent cache keys :(
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

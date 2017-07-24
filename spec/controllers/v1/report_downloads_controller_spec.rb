require'spec_helper'

describe V1::ReportDownloadsController do
  describe 'GET #VariantReport(ExcelFormat)' do
    it 'should route to the correct controller' do
      expect(get: 'api/v1/patients/3366/variant_report/3366_job1').to route_to(controller: 'v1/report_downloads', action: 'variant_report_download',
                                                                               'patient_id' => '3366', 'analysis_id' => '3366_job1')
    end

    it 'should route to the correct controller' do
      expect(get: 'api/v1/patients/3366/assignment_report/d6c03b15-f0c3-4b4c-a810-007f919f399d').to route_to(controller: 'v1/report_downloads', action: 'assignment_report_download',
                                                                                                             'patient_id' => '3366', 'uuid' => 'd6c03b15-f0c3-4b4c-a810-007f919f399d')
    end

    it 'should throw 404 if the patient is not found' do
      allow(NciMatchPatientModels::Patient).to receive(:query_patient_by_id).and_return('')
      get :variant_report_download, params: {patient_id: '', analysis_id: '3366_job1'}
      expect(response).to have_http_status(404)
    end

    it 'Should generate a proper Variant Report excel sheet' do
      patient = NciMatchPatientModels::Patient.new
      patient.patient_id = '3366'
      patient.registration_date = DateTime.current.getutc().to_s
      allow(NciMatchPatientModels::Patient).to receive(:query).and_return([patient])

      variant_report = { patient_id: '3366', variant_report_type: 'TISSUE', analysis_id: '3366_job1' }

      variant1 = NciMatchPatientModels::Variant.new
      variant1.uuid = 'd6c03b15-f0c3-4b4c-a810-007f919f399d'
      variant1.variant_type = 'snp'
      variant1.amois = []
      variant1.confirmed = false
      variant1.molecular_id = 'mo-1234'
      variant1.analysis_id = 'an-1234'

      variant2 = NciMatchPatientModels::Variant.new
      variant2.uuid = 'random2'
      variant2.variant_type = 'fusion'
      variant2.amois = [{ 'treatment_id' => 'A', 'stratum_id' => '100', 'version' => '2016' }]
      variant2.confirmed = true
      variant2.molecular_id = 'mo-1234'
      variant2.analysis_id = 'an-1234'

      variant_report[:snv_indels] = [variant1.to_h]
      variant_report[:gene_fusions] = [variant2.to_h]

      allow(NciMatchPatientModelExtensions::VariantReportExtension).to receive(:compose_variant_report).and_return(variant_report)

      get :variant_report_download, as: :xlsx, params: {patient_id: '3366', analysis_id: '3366_job1'}
      expect(response.content_type.to_s).to eq(Mime::Type.lookup_by_extension(:xlsx).to_s)
    end

    it 'Should generate a proper Assignment Report excel sheet' do
      get :assignment_report_download, as: :xlsx, params: {patient_id: '3366', uuid: 'd6c03b15-f0c3-4b4c-a810-007f919f399d'}
      expect(response.content_type.to_s).to eq(Mime::Type.lookup_by_extension(:xlsx).to_s)
    end

    it 'should return variant report for a patient if there is one' do
      patient = NciMatchPatientModels::Patient.new
      patient.patient_id = '3366'
      patient.registration_date = DateTime.current.getutc().to_s
      allow(NciMatchPatientModels::Patient).to receive(:query).and_return([patient])

      variant_report = { patient_id: '3366', variant_report_type: 'TISSUE', analysis_id: '3366_job1' }

      variant1 = NciMatchPatientModels::Variant.new
      variant1.uuid = 'd6c03b15-f0c3-4b4c-a810-007f919f399d'
      variant1.variant_type = 'snp'
      variant1.amois = []
      variant1.confirmed = false
      variant1.molecular_id = 'mo-1234'
      variant1.analysis_id = 'an-1234'

      variant2 = NciMatchPatientModels::Variant.new
      variant2.uuid = 'random2'
      variant2.variant_type = 'fusion'
      variant2.amois = [{ 'treatment_id' => 'A', 'stratum_id' => '100', 'version' => '2016' }]
      variant2.confirmed = true
      variant2.molecular_id = 'mo-1234'
      variant2.analysis_id = 'an-1234'

      variant_report[:snv_indels] = [variant1.to_h]
      variant_report[:gene_fusions] = [variant2.to_h]

      allow(NciMatchPatientModelExtensions::VariantReportExtension).to receive(:compose_variant_report).and_return(variant_report)

      get :variant_report_download, params: {patient_id: '3366', analysis_id: '3366_job1'}
      expect(response).to have_http_status(200)
    end

    it 'should return Assignment Report for a patient' do
      patient = NciMatchPatientModels::Patient.new
      patient.patient_id = '3366'
      patient.registration_date = DateTime.current.getutc().to_s
      allow(NciMatchPatientModels::Patient).to receive(:query).and_return([patient])

      assignment = NciMatchPatientModels::Assignment.new
      assignment.patient_id = '3366'
      assignment.uuid = 'd6c03b15-f0c3-4b4c-a810-007f919f399d'
      assignment.assignment_date = DateTime.current.getutc().to_s
      assignment.surgical_event_id = 'ei-1234'
      allow(NciMatchPatientModels::Assignment).to receive(:query).and_return([assignment])

      specimen = NciMatchPatientModels::Specimen.new
      specimen.patient_id = '3366'
      specimen.collected_date = DateTime.current.getutc().to_s
      allow(NciMatchPatientModels::Specimen).to receive(:scan).and_return([specimen])

      get :assignment_report_download, params: {patient_id: '3366', uuid: 'd6c03b15-f0c3-4b4c-a810-007f919f399d'}
      expect(response).to have_http_status(200)
    end
  end

  describe 'Error Handling' do
    it 'should handle malformed requests correctly' do
      expect(get: 'api/v1/patients/3366/variant_report').to route_to(controller: 'v1/errors', action: 'bad_request', path: 'patients/3366/variant_report')
    end
  end

  describe 'Axlsx renderer' do
    it 'should be registered' do
      expect(ActionController::Renderers::RENDERERS.include?(:xlsx))
    end
  end
end

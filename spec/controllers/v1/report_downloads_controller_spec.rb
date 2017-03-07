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

    it 'Should generate a proper Variant Report excel sheet' do
      get :variant_report_download, format: :xlsx, patient_id: '3366', analysis_id: '3366_job1'
      response.content_type.to_s.should eq Mime::Type.lookup_by_extension(:xlsx).to_s
    end

    it 'Should generate a proper Assignment Report excel sheet' do
      get :assignment_report_download, format: :xlsx, patient_id: '3366', uuid: 'd6c03b15-f0c3-4b4c-a810-007f919f399d'
      response.content_type.to_s.should eq Mime::Type.lookup_by_extension(:xlsx).to_s
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

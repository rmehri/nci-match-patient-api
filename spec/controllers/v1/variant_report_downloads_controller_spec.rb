describe V1::VariantReportDownloadsController do

  describe 'GET #VariantReport(ExcelFormat)' do
    it 'should route to the correct controller' do
      expect(get: 'api/v1/patients/3366/variant_report/3366_job1').to route_to(controller: 'v1/variant_report_downloads', action: 'download_excel',
                                                                               'patient_id' => '3366', 'analysis_id' => '3366_job1')
    end
  end

  describe 'Error Handling' do
    it 'should handle malformed requests correctly' do
      expect(get: 'api/v1/patients/3366/variant_report').to route_to(controller: 'v1/errors', action: 'bad_request',
       path: 'patients/3366/variant_report')
    end
  end
end
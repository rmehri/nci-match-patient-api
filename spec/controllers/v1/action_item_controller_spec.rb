
describe V1::ActionItemsController, type: :controller do

  describe 'should return valid data model' do
    it 'single VariantReport object return' do
      allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([{ molecular_id: '123', analysis_id: 'ABC', variant_report_type: 'TISSUE', status_date: Date.current, uuid: '1cbe6e30-ffa0-4842-8017-7deda9d19115' }])

      patient = NciMatchPatientModels::Patient.new
      patient.patient_id = "3366"
      patient.current_status = "TISSUE_VARIANT_REPORT_RECEIVED"
      allow(NciMatchPatientModels::Patient).to receive(:query).and_return([patient])

      get :index, params: {patient_id: '123'}
      expect(JSON.parse(response.body)).to eq([{ 'action_type' => 'pending_tissue_variant_report', 'molecular_id' => '123', 'analysis_id' => 'ABC', 'created_date' => Date.current.to_s, 'assignment_uuid' =>  '1cbe6e30-ffa0-4842-8017-7deda9d19115' }])
    end

    it 'multiple VariantReport object return' do
      allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([{ molecular_id: '123', analysis_id: 'ABC', variant_report_type: 'TISSUE', status_date: Date.current, uuid: '1cbe6e30-ffa0-4842-8017-7deda9d19115' },
                                                                                { molecular_id: '321', analysis_id: 'CBA', variant_report_type: 'BLOOD', status_date: Date.current, uuid: '03e6ebc1-0aff-2484-7108-8efab8e2625' }])
      patient = NciMatchPatientModels::Patient.new
      patient.patient_id = "3366"
      patient.current_status = "TISSUE_VARIANT_REPORT_RECEIVED"
      allow(NciMatchPatientModels::Patient).to receive(:query).and_return([patient])

      get :index, params: {patient_id: '123'}
      expect(JSON.parse(response.body)).to eq([{ 'action_type' => 'pending_tissue_variant_report', 'molecular_id' => '123', 'analysis_id' => 'ABC', 'created_date' => Date.current.to_s, 'assignment_uuid' => '1cbe6e30-ffa0-4842-8017-7deda9d19115' }, {'action_type' => 'pending_blood_variant_report', 'molecular_id' => '321', 'analysis_id' => 'CBA', 'created_date' => Date.current.to_s, 'assignment_uuid' => '03e6ebc1-0aff-2484-7108-8efab8e2625' }])
    end

    it 'single Assignment object return' do
      allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([{ molecular_id: '123', analysis_id: 'ABC', status_date: Date.current, uuid: '1cbe6e30-ffa0-4842-8017-7deda9d19115'}])

      patient = NciMatchPatientModels::Patient.new
      patient.patient_id = "3366"
      patient.current_status = "TISSUE_VARIANT_REPORT_RECEIVED"
      allow(NciMatchPatientModels::Patient).to receive(:query).and_return([patient])

      get :index, params: {patient_id: '123'}
      expect(JSON.parse(response.body)).to eq([{ 'action_type' => 'pending_assignment_report', 'molecular_id' => '123', 'analysis_id' => 'ABC', 'created_date' => Date.current.to_s, 'assignment_uuid' => '1cbe6e30-ffa0-4842-8017-7deda9d19115' }])
    end

    it 'multiple Assignment object return' do
      allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([{ molecular_id: '123', analysis_id: 'ABC', status_date: Date.current, uuid: '1cbe6e30-ffa0-4842-8017-7deda9d19115'},
                                                                             { molecular_id: '321', analysis_id: 'CBA', status_date: Date.current, uuid: '03e6ebc1-0aff-2484-7108-8efab8e2625'}])

      patient = NciMatchPatientModels::Patient.new
      patient.patient_id = "3366"
      patient.current_status = "TISSUE_VARIANT_REPORT_RECEIVED"
      allow(NciMatchPatientModels::Patient).to receive(:query).and_return([patient])

      get :index, params: {patient_id: '123'}
      expect(JSON.parse(response.body)).to eq([{ 'action_type' => 'pending_assignment_report', 'molecular_id' => '123', 'analysis_id' => 'ABC', 'created_date' => Date.current.to_s, 'assignment_uuid' => '1cbe6e30-ffa0-4842-8017-7deda9d19115' }, { 'action_type' => 'pending_assignment_report', 'molecular_id' => '321', 'analysis_id' => 'CBA', 'created_date' => Date.current.to_s, 'assignment_uuid' => '03e6ebc1-0aff-2484-7108-8efab8e2625' }])
    end

    it 'mix and match multiple' do
      allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([{molecular_id: '321', analysis_id: 'CBA', status_date: Date.current, uuid: '03e6ebc1-0aff-2484-7108-8efab8e2625'}])
      allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([{molecular_id: '123', analysis_id: 'ABC', variant_report_type: 'TISSUE', status_date: Date.current, uuid: '03e6ebc1-0aff-2484-7108-8efab8e2625'}])

      patient = NciMatchPatientModels::Patient.new
      patient.patient_id = "3366"
      patient.current_status = "TISSUE_VARIANT_REPORT_RECEIVED"
      allow(NciMatchPatientModels::Patient).to receive(:query).and_return([patient])

      get :index, params: {patient_id: '123'}
      expect(JSON.parse(response.body)).to eq([{ 'action_type' => 'pending_tissue_variant_report', 'molecular_id' => '123', 'analysis_id' => 'ABC', 'created_date' => Date.current.to_s, 'assignment_uuid' => '03e6ebc1-0aff-2484-7108-8efab8e2625'}, {'action_type' => 'pending_assignment_report', 'molecular_id' => '321', 'analysis_id' => 'CBA', 'created_date' => Date.current.to_s, 'assignment_uuid' => '03e6ebc1-0aff-2484-7108-8efab8e2625' }])
    end
  end

  describe 'should return empty when errors out' do
    it 'have valid http code and empty array return' do
      allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([])
      allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([])

      patient = NciMatchPatientModels::Patient.new
      patient.patient_id = "3366"
      patient.current_status = "TISSUE_VARIANT_REPORT_RECEIVED"
      allow(NciMatchPatientModels::Patient).to receive(:query).and_return([patient])

      get :index, params: {patient_id: 'random'}
      expect(response).to have_http_status(200)
      expect(response.body).to eq('[]')
    end
  end

  it 'should have a valid route' do
    expect(get: 'api/v1/patients/1/action_items').to route_to(controller: 'v1/action_items', action: 'index', patient_id: '1')
  end
end

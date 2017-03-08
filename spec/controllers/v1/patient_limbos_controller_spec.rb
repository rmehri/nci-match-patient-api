require 'rails_helper'


RSpec.describe V1::PatientLimbosController, :type => :controller do

  context 'route #GET patient_limbos' do
    it { expect(:get => "api/v1/patients/patient_limbos").to route_to(:controller => "v1/patient_limbos",
                                                                                               :action => "index")}
  end

  context '#GET patient_limbos' do

    let(:patient_zero) { {:active_tissue_specimen => {:specimen_received_date => (Date.current - 8.days).to_s},
                         :patient_id => "0_test", :current_status => 'PENDING_APPROVAL'} }
    #copy of above to prove that uniq! is working
    let(:patient_one) { {:active_tissue_specimen => {:specimen_received_date => (Date.current - 8.days).to_s},
                          :patient_id => "0_test", :current_status => 'PENDING_APPROVAL'} }
    let(:patient_current_status_pending) { {:active_tissue_specimen => {:active_molecular_id => "mole_id",
                                                     :specimen_received_date => (Date.current - 7.days).to_s},
                         :patient_id => "2_test", :current_status => 'PENDING_APPROVAL'} }
    let(:patient_variant_status_rejected) { {:active_tissue_specimen => {:active_molecular_id => "mole_id",
                                                     :active_analysis_id => "active_id",
                                                       :variant_report_status => 'REJECTED',
                                                     :specimen_received_date => (Date.current - 7.days).to_s},
                         :patient_id => "3_test", :current_status => 'PENDING_APPROVAL'} }

    let(:patient_variant_status_pending) { {:active_tissue_specimen => {:active_molecular_id => "mole_id",
                                                       :active_analysis_id => "active_id",
                                                       :variant_report_status => 'PENDING',
                                                       :specimen_received_date => (Date.current - 7.days).to_s},
                           :patient_id => "4_test", :current_status => 'PENDING_APPROVAL'} }


    :active_molecular_id
    let(:safety_pig) { {:patient_id => "safety_pig",
                        :active_tissue_specimen => {:specimen_received_date => (Date.current - 4.days).to_s}}}

    it 'return data correctly' do
      allow(NciMatchPatientModels::Patient).to receive(:scan).and_return([patient_zero, patient_one,
                                                                          patient_current_status_pending,
                                                                          patient_variant_status_rejected,
                                                                          patient_variant_status_pending,
                                                                          safety_pig])
      get :index
      expect(JSON.parse(response.body).length). to eq(4)
    end

    it 'fail gracefully' do
      allow(NciMatchPatientModels::Patient).to receive(:scan).and_return(nil)
      get :index
      expect{response}.not_to raise_error
      expect(response.body).to eq("")
    end

    it 'return blank if nothing is found' do
      allow(NciMatchPatientModels::Patient).to receive(:scan).and_return([])
      get :index
      expect(response.body).to be_truthy
      expect(response.body).to eq("[]")
    end

  end

end
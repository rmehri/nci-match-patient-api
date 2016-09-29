require 'rails_helper'
require 'factory_girl_rails'
require 'aws-record'
require 'nci_match_patient_models'

describe Convert::VariantReportDbModel do

  let(:variant_report_db) do

    stub_model NciMatchPatientModels::VariantReport,
               :patient_id => 'PAT123',
               :variant_report_received_date => '2016-05-09T22:06:33+00:00',
               :study_id => 'APEC1621',
               :surgical_event_id => "3366-bsn",
               :variant_report_type => "TISSUE",
               :molecular_id => "3366-bsn-msn-2",
                :analysis_id => "job1",
                :status => "CONFIRMED",
                :status_date => "2016-09-29T18:41:42+00:00"

  end

  let(:variant1_db) do

    stub_model NciMatchPatientModels::Variant,
               :patient_id => 'PAT123',
               :variant_type => "snp",
              :surgical_event_id => "3366-bsn",
                :molecular_id => "3366-bsn-msn-2",
                :analysis_id => "job1",
                :confirmed => true,
                :status_date => "2016-09-29T18:35:45+00:00",
                :is_amoi => false,
                :amois => [],
                :identifier => "COSM775",
                :func_gene => "PIK3CA",
                :chromosome => "chr3",
                :position => "178952085"

  end

  let(:variant2_db) do

    stub_model NciMatchPatientModels::Variant,
               :patient_id => 'PAT123',
               :variant_type => "snp",
               :surgical_event_id => "3366-bsn",
               :molecular_id => "3366-bsn-msn-2",
               :analysis_id => "job1",
               :confirmed => true,
               :status_date => "2016-09-29T18:35:45+00:00",
               :is_amoi => false,
               :amois => [],
               :identifier => "COSM775",
               :func_gene => "PIK3CA",
               :chromosome => "chr3",
               :position => "178952085"

  end

  # it 'should do something' do
  #
  #   true.should == false
  # end
end
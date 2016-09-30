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
               :uuid => "8765654",
               :patient_id => 'PAT123',
               :variant_type => "snp",
              :surgical_event_id => "3366-bsn",
                :molecular_id => "3366-bsn-msn-2",
                :analysis_id => "job1",
                :confirmed => false,
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
               :uuid => "23232323232",
               :patient_id => 'PAT123',
               :variant_type => "fusion",
               :variant_type => "fusion",
               :surgical_event_id => "3366-bsn",
               :molecular_id => "3366-bsn-msn-2",
               :analysis_id => "job1",
               :confirmed => true,
               :status_date => "2016-09-29T18:35:45+00:00",
                :identifier => "TPM3-ALK.T7A20",
               :amois => [
                {
                  :treatment_arm_id => "APEC1621-A",
                  :stratum_id => "100",
                  :version => "2015-08-06",
                  :amoi_status => "CURRENT",
                  :exclusion => false
              }]
  end

  let(:variant_report_from_rule) do
    {
        "ion_reporter_id"=>"IR_WAO85",
        "molecular_id"=>"3366-bsn-msn-blood",
        "analysis_id"=>"job2",
        "filename"=>"3366",
        "total_variants"=>7,
        "mapd"=>"0.439",
        "cellularity"=>"1.000000",
        "torrent_variant_caller_version"=>"5.0-9",
        "snv_indels"=>[
            {
            "variant_type"=>"snp",
            "identifier"=>"COSM775",
            "filter"=>"PASS",
            "amois"=>[],
            "chromosome"=>"chr3",
            "position"=>"178952085",
          "ocp_reference"=>"A",
          "ocp_alternative"=>"G"

        }],

        "gene_fusions" => [
        {
            "variant_type" => "fusion",
            "identifier" => "TPM3-ALK.T7A20",
            "filter" => "PASS",
            "amois" => [
            {
              "treatment_arm_id" => "from_rule",
              "stratum_id" => "100",
              "version" => "2015-08-06",
              "amoi_status" => "CURRENT",
              "exclusion" =>false
            }]
        }]
      }
  end

  it 'should convert assignment data to ui format' do
    assign_from_rule = variant_report_from_rule.deep_symbolize_keys
    ui_model = Convert::VariantReportDbModel.to_ui_model(variant_report_db.to_h, [variant1_db.to_h, variant2_db.to_h], assign_from_rule)
    # puts "======== ui model: #{ui_model}"

    expect(ui_model[:total_amois]).to eq(1)
    expect(ui_model[:total_confirmed_amois]).to eq(1)
    expect(ui_model[:total_confirmed_mois]).to eq(1)

    expect(ui_model[:gene_fusions][0][:amois][0][:treatment_arm_id]).to eq("from_rule")
  end
end
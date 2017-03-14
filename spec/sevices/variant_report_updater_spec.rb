require 'rails_helper'


RSpec.describe VariantReportUpdater do


  context 'update variant report' do
    let(:variant_report_updater) { VariantReportUpdater.new }
    it 'fail gracefully ' do
      allow(TreatmentArmApi).to receive(:get_treatment_arms).and_return({})
      expect{variant_report_updater.updated_variant_report({}, "token")}.to raise_error
    end

    it 'return a updated variant_report' do
      allow(TreatmentArmApi).to receive(:get_treatment_arms).and_return({})
      allow(RuleEngine).to receive(:get_mois).and_return({:variant_report => "data"}.to_json)
      expect(variant_report_updater.updated_variant_report({}, "token")).to be_truthy
    end

  end

end
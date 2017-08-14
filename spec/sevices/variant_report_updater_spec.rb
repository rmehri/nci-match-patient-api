require 'rails_helper'

RSpec.describe VariantReportUpdater do

  context 'update variant report' do
    it 'fail gracefully ' do
      allow(TreatmentArmApi).to receive(:get_treatment_arms).and_return({})
      expect{VariantReportUpdater.updated_variant_report({}, "request", "token")}.to raise_error(TypeError)
    end

    it 'return a updated variant_report' do
      allow(TreatmentArmApi).to receive(:get_treatment_arms).and_return({})
      allow(RuleEngine).to receive(:get_mois).and_return({:variant_report => "data"}.to_json)
      expect(VariantReportUpdater.updated_variant_report({}, "request", "token")).to be_truthy
    end

  end
end

require 'spec_helper'

RSpec.describe TreatmentArmMessage do

  let (:validator) {TreatmentArmMessage}

  context "initialize correctly" do
    it { expect(validator).to be_truthy }
  end

  context "validate a valid message" do
    it {expect(TreatmentArmMessage.new.from_json({:treatment_arms => "123"}.to_json).valid?).to be_truthy}
  end

  context "fail a invalid message" do
    it {expect(TreatmentArmMessage.new.from_json({:not_correct => ""}.to_json).valid?).to be_falsey}
    it {expect(TreatmentArmMessage.new.from_json({}.to_json).valid?).to be_falsey}
  end

end
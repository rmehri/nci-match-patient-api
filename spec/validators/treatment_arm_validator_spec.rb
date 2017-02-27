require 'spec_helper'

RSpec.describe MessageValidator::TreatmentArmsValidator do

  let (:validator) {MessageValidator::TreatmentArmsValidator}

  context "initialize correctly" do
    it { expect(validator).to be_truthy }
    it { expect(MessageValidator.validate_json_message("TreatmentArms", "Random")).to be_truthy }
  end

  context "validate a valid message" do
    it {expect(MessageValidator.validate_json_message("TreatmentArms", {:treatment_arms => "123"})).to eq(nil) }
  end

  context "fail a invalid message" do
    it {expect(MessageValidator.validate_json_message("TreatmentArms", {:not_correct => ""})).not_to eq(nil) }
    it {expect(MessageValidator.validate_json_message("TreatmentArms", {})).not_to eq(nil) }
  end

end
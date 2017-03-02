require 'spec_helper'

RSpec.describe MessageValidator::EventValidator do

  let (:validator) {MessageValidator::EventValidator}

  let (:valid_message) { {:patient_id => "123", :molecular_id => "123-mole",
                          :surgical_event_id => "123-surg", :analysis_id => "123-ana"}  }
  let (:valid_file_message) { {:patient_id => "123", :molecular_id => "123-mole",
                          :surgical_event_id => "123-surg", :analysis_id => "123-ana", :rna_file_name => "test.bam",
                               :dna_file_name => "test.bam", :vcf_file_name => "test.zip"} }

  let (:invalid_message) { {:patient_id => "123"} }
  let (:invalid_file_message) { {:patient_id => "123", :molecular_id => "123-mole",
                                 :surgical_event_id => "123-surg", :analysis_id => "123-ana", :rna_file_name => "test.zip",
                                 :dna_file_name => "test.test", :vcf_file_name => "test.bam"} }

  context "initialize correctly" do
    it { expect(validator).to be_truthy }
    it { expect(MessageValidator.validate_json_message("Event", "Random")).to be_truthy }
  end

  context "validate a valid message" do
    it {expect(MessageValidator.validate_json_message("Event", valid_message)).to eq(nil) }
  end

  context "validate a valid file message" do
    it {expect(MessageValidator.validate_json_message("Event", valid_file_message)).to eq(nil)}
  end

  context "fail a invalid message" do
    it {expect(MessageValidator.validate_json_message("Event", invalid_message)).not_to eq(nil) }
  end

  context "fail a invalid file message" do
    it {expect(MessageValidator.validate_json_message("Event", invalid_file_message)).not_to eq(nil) }
  end



end
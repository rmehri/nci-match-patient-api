require 'spec_helper'

RSpec.describe MessageValidator::EventValidator do

  let (:validator) {EventMessage}

  let (:valid_message) { {:patient_id => "123", :molecular_id => "123-mole",
                          :surgical_event_id => "123-surg", :analysis_id => "123-ana"}  }
  let (:valid_file_message) { {:patient_id => "123", :molecular_id => "123-mole",
                          :surgical_event_id => "123-surg", :analysis_id => "123-ana", :cdna_bam_name => "test.bam",
                               :dna_bam_name => "test.bam", :zip_name => "test.zip"} }

  let (:invalid_message) { {:patient_id => "123"} }
  let (:invalid_file_message) { {:patient_id => "123", :molecular_id => "123-mole",
                                 :surgical_event_id => "123-surg", :analysis_id => "123-ana", :cdna_bam_name => "test.zip",
                                 :dna_bam_name => "test.test", :zip_name => "test.bam"} }

  context "initialize correctly" do
    it { expect(validator).to be_truthy }
  end

  context "validate a valid message" do
    it {expect(EventMessage.new.from_json(valid_message.to_json).valid?).to be_truthy}
  end

  context "validate a valid file message" do
    it {expect(EventMessage.new.from_json(valid_file_message.to_json).valid?).to be_truthy}
  end

  context "fail a invalid message" do
    it {expect(EventMessage.new.from_json(invalid_message.to_json).valid?).to be_falsey}
  end

  context "fail a invalid file message" do
    it {expect(EventMessage.new.from_json(invalid_file_message.to_json).valid?).to be_falsey}
  end

end
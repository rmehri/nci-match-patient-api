require 'spec_helper'


RSpec.describe MessageValidator::AssignmentStatusValidator do

  # :patient_id,
  #     :molecular_id,
  #     :analysis_id,
  #     :status,
  #     :status_type,
  #     :comment,
  #     :comment_user

  let (:validator) {MessageValidator::AssignmentStatusValidator}
  let (:valid_message) { {:patient_id => "123", :analysis_id => "#{Time.now}", :status => "CONFIRMED", :status_type => "ASSIGNMENT"}  }

  context "initialize correctly" do
    it { expect(validator).to be_truthy }
    it { expect(MessageValidator.validate_json_message("AssignmentStatus", "Random")).to be_truthy }
  end

  context "validate a valid message" do
    it {expect(MessageValidator.validate_json_message("AssignmentStatus", valid_message)).to eq(nil) }
  end

  context "fail a invalid message" do
    it {expect(MessageValidator.validate_json_message("Event", {:patient_id => "123", :analysis_id => "#{Time.now}", :status => "CONFIRMED", :status_type => "NOT_CORRECT"} )).not_to eq(nil) }
    it {expect(MessageValidator.validate_json_message("Event", {:patient_id => "123", :analysis_id => "#{Time.now}", :status => "NOT_CORRECT", :status_type => "ASSIGNMENT"} )).not_to eq(nil) }
    it {expect(MessageValidator.validate_json_message("Event", {:analysis_id => "#{Time.now}", :status => "CONFIRMED", :status_type => "ASSIGNMENT"} )).not_to eq(nil) }
    it {expect(MessageValidator.validate_json_message("Event", {:patient_id => "123", :status => "NOT_CORRECT", :status_type => "ASSIGNMENT"} )).not_to eq(nil) }
    it {expect(MessageValidator.validate_json_message("Event", {} )).not_to eq(nil) }
  end



end
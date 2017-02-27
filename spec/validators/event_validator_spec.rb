require 'spec_helper'

RSpec.describe MessageValidator::EventValidator do

  let (:validator) {MessageValidator::EventValidator}
  let (:valid_message) { {:entity_id => "123", :event_date => "#{Time.now}"}  }
  let (:invalid_message) { {:event_id => "123"} }

  context "initialize correctly" do
    it { expect(validator).to be_truthy }
    it { expect(MessageValidator.validate_json_message("Event", "Random")).to be_truthy }
  end

  context "validate a valid message" do
    it {expect(MessageValidator.validate_json_message("Event", valid_message)).to eq(nil) }
  end

  context "fail a invalid message" do
    it {expect(MessageValidator.validate_json_message("Event", invalid_message)).not_to eq(nil) }
  end



end
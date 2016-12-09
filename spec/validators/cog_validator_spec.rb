require 'rails_helper'
require 'spec_helper'

describe 'CogValidator behavior' do

  context 'for REGISTRATION ' do
    good_message = FactoryGirl.build(:good_message_registration).to_json
    bad_message = FactoryGirl.build(:bad_message_registration).to_json

    it "should get type 'Cog' from MessageValidator" do
      message = JSON.parse(good_message)
      message.deep_transform_keys!(&:underscore).symbolize_keys!
      type = MessageValidator.get_message_type(message)
      expect(type).to eq('Cog')
    end

    it "should validate a good message" do
      message = JSON.parse(good_message)
      valid = MessageValidator::CogValidator.new.from_json(message.to_json).valid?
      expect(valid).to be_truthy
    end

    it "should invalidate a bad message" do
      message = JSON.parse(bad_message)
      valid = MessageValidator::CogValidator.new.from_json(message.to_json).valid?
      expect(valid).to be_falsey
    end

    it "should return a valid message when error" do
      message = JSON.parse(bad_message)
      message_validator = MessageValidator::CogValidator.new.from_json(message.to_json)
      expect(message_validator.valid?).to be_falsey
      expect(message_validator.errors.messages).not_to be_empty
      expect(message_validator.errors.messages.to_s).to include("can't be blank")
    end
  end

  context 'for ON_TREATMENT_ARM ' do
    good_message = FactoryGirl.build(:good_message_on_treatment_arm).to_json
    bad_message = FactoryGirl.build(:bad_message_on_treatment_arm).to_json

    it "should get type 'Cog' from MessageValidator" do
      message = JSON.parse(good_message)
      message.deep_transform_keys!(&:underscore).symbolize_keys!
      type = MessageValidator.get_message_type(message)
      expect(type).to eq('Cog')
    end

    it "should validate a good message" do
      message = JSON.parse(good_message)
      valid = MessageValidator::CogValidator.new.from_json(message.to_json).valid?
      expect(valid).to be_truthy
    end

    it "should invalidate a bad message" do
      message = JSON.parse(bad_message)
      valid = MessageValidator::CogValidator.new.from_json(message.to_json).valid?
      expect(valid).to be_falsey
    end

    it "should return a valid message when error" do
      message = JSON.parse(bad_message)
      message_validator = MessageValidator::CogValidator.new.from_json(message.to_json)
      expect(message_validator.valid?).to be_falsey
      expect(message_validator.errors.messages).not_to be_empty
      expect(message_validator.errors.messages.to_s).to include("can't be blank")
    end
  end

  context 'for OFF_STUDY ' do
    good_message = FactoryGirl.build(:good_message_off_study).to_json
    bad_message = FactoryGirl.build(:bad_message_off_study).to_json

    it "should get type 'Cog' from MessageValidator" do
      message = JSON.parse(good_message)
      message.deep_transform_keys!(&:underscore).symbolize_keys!
      type = MessageValidator.get_message_type(message)
      expect(type).to eq('Cog')
    end

    it "should validate a good message" do
      message = JSON.parse(good_message)
      valid = MessageValidator::CogValidator.new.from_json(message.to_json).valid?
      expect(valid).to be_truthy
    end

    it "should invalidate a bad message" do
      message = JSON.parse(bad_message)
      valid = MessageValidator::CogValidator.new.from_json(message.to_json).valid?
      expect(valid).to be_falsey
    end

    it "should return a valid message when error" do
      message = JSON.parse(bad_message)
      message_validator = MessageValidator::CogValidator.new.from_json(message.to_json)
      expect(message_validator.valid?).to be_falsey
      expect(message_validator.errors.messages).not_to be_empty
      expect(message_validator.errors.messages.to_s).to include("can't be blank")
    end
  end

  context 'for REQUEST_ASSIGNMENT' do
    good_message = FactoryGirl.build(:good_message_request_assignment).to_json
    bad_message = FactoryGirl.build(:bad_message_request_assignment).to_json

    it "should get type 'Cog' from MessageValidator" do
      message = JSON.parse(good_message)
      message.deep_transform_keys!(&:underscore).symbolize_keys!
      type = MessageValidator.get_message_type(message)
      expect(type).to eq('Cog')
    end

    it "should validate a good message" do
      message = JSON.parse(good_message)
      valid = MessageValidator::CogValidator.new.from_json(message.to_json).valid?
      expect(valid).to be_truthy
    end

    it "should invalidate a bad message" do
      message = JSON.parse(bad_message)
      valid = MessageValidator::CogValidator.new.from_json(message.to_json).valid?
      expect(valid).to be_falsey
    end

    it "should return a valid message when error" do
      message = JSON.parse(bad_message)
      message_validator = MessageValidator::CogValidator.new.from_json(message.to_json)
      expect(message_validator.valid?).to be_falsey
      expect(message_validator.errors.messages).not_to be_empty
      expect(message_validator.errors.messages.to_s).to include("can't be blank")
    end
  end

end
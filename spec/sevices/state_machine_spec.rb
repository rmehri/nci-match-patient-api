require 'rails_helper'
require 'factory_girl_rails'
require 'httparty'
require 'httparty/request'

describe StateMachine do
  let(:valid_message) do
    msg = '{"valid": "true"}'
    msg.to_s
  end

  let(:invalid_message) do
    msg = '{"valid": "false"}'
    msg.to_s
  end

  it "valid message should validate" do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Request).to receive(:perform).and_return(true)
    # allow(StateMachine).to receive(:validate).and_return(true)
    expect(StateMachine.validate(valid_message)).to eq true
  end

  it "invalid message should not validate" do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Request).to receive(:perform).and_return(false)
    # allow(StateMachine).to receive(:validate).and_return(false)
    expect(StateMachine.validate(invalid_message)).to eq false
  end
end

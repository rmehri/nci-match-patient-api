require 'rails_helper'
require 'factory_girl_rails'

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
    allow(StateMachine).to receive(:validate).and_return(true)
    expect(StateMachine.validate(valid_message)).to eq true
  end

  it "invalid message should not validate" do
    allow(StateMachine).to receive(:validate).and_return(false)
    expect(StateMachine.validate(invalid_message)).to eq false
  end
end

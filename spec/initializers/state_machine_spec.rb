require 'rails_helper'
require 'factory_girl_rails'

describe NciMatchPatientApi::StateMachine do
  let(:valid_message) do
    {:valid => true}
  end

  let(:invalid_message) do
    {:valid => false}
  end

  it "valid message should validate" do
    expect(NciMatchPatientApi::StateMachine.validate(valid_message)).to eq true
  end

  it "invalid message should not validate" do
    expect(NciMatchPatientApi::StateMachine.validate(invalid_message)).to eq false
  end
end

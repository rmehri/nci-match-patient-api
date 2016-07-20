require 'rails_helper'
require 'factory_girl_rails'
require 'httparty/response'
require 'httparty/request'

describe StateMachine do
  let(:valid_message) do
    '{"valid": "true"}'
  end

  let(:invalid_message) do
     '{"valid": "false"}'
  end

  it "valid message should validate" do
    message_body = {"status" => "Failure", "error" => "some error"}
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Request).to receive(:perform).and_return("true")
    expect(StateMachine.validate(valid_message)).to eq "true"
  end

  it "invalid message should not validate" do
    error_body = {"status" => "Failure", "error" => "some error"}
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Request).to receive(:perform).and_return(error_body)

    res = StateMachine.validate(invalid_message)
    expect(res).to eq(error_body)
  end
end

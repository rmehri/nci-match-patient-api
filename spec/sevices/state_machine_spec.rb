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
    message_body = {"status" => "Success", "error" => "some error"}

    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:body).and_return(message_body)
    expect(StateMachine.validate(valid_message)).to eq(message_body)

  end

  it "invalid message should not validate" do
    error_body = {"status" => "Failure", "error" => "some error"}

    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:body).and_return(error_body)

    res = StateMachine.validate(invalid_message)
    expect(res).to eq(error_body)
  end
end

require 'json'

describe ConfirmResult do
  def getTestable
    testable = ConfirmResult.new
    testable.status = 'CONFIRMED'
    testable.comment = 'Some Comments'
    return testable
  end

  it "can be created" do
    testable = getTestable

    expect(testable.status).to eq('CONFIRMED')
    expect(testable.comment).to eq('Some Comments')
  end

  it "can convert from json" do
    json_string = '{"status":"CONFIRMED","comment":"Some Comments"}';

    model = ConfirmResult.from_json json_string

    expect(model).to_not eq nil
    expect(model.status).to eq("CONFIRMED")
    expect(model.comment).to eq('Some Comments')

  end

  it "can convert to json" do
    testable = getTestable

    json_string = testable.to_json

    expect {
      JSON.parse(json_string)
    }.to_not raise_error

  end
end
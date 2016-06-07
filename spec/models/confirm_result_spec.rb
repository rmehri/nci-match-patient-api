require 'json'

describe ConfirmResult do
  def getTestable
    testable = ConfirmResult.new
    testable.confirmed = true
    testable.comments = 'Some Comments'
    return testable
  end

  it "can be created" do
    testable = getTestable

    expect(testable.confirmed).to eq(true)
    expect(testable.comments).to eq('Some Comments')
  end

  it "can convert from json" do
    json_string = '{"confirmed":"true","comments":"Some Comments"}';

    model = ConfirmResult.from_json json_string

    expect(model).to_not eq nil
    expect(model.confirmed).to eq("true")
    expect(model.comments).to eq('Some Comments')

  end

  it "can convert to json" do
    testable = getTestable

    json_string = testable.to_json

    expect {
      JSON.parse(json_string)
    }.to_not raise_error

  end
end
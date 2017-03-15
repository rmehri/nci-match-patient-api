require 'json'

describe ConfirmVariantMessage do
  def get_testable
    testable = ConfirmVariantMessage.new
    testable.status = 'CONFIRMED'
    testable.comment = 'Some Comments'
    return testable
  end

  it "can be created" do
    testable = get_testable
    expect(testable.status).to eq('CONFIRMED')
    expect(testable.comment).to eq('Some Comments')
  end

  it "can convert from json" do
    json_string = '{"status":"CONFIRMED","comment":"Some Comments"}'
    model = ConfirmVariantMessage.from_json json_string
    expect(model).to_not eq nil
    expect(model.status).to eq("CONFIRMED")
    expect(model.comment).to eq('Some Comments')

  end

  it {expect{ConfirmVariantMessage.from_url({})}.to raise_error(ActionController::BadRequest)}
  it {expect{ConfirmVariantMessage.from_url(nil)}.to raise_error(ActionController::BadRequest)}

  it {expect{ConfirmVariantMessage.from_url(["cat", "dog", "mouse"])}.to raise_error(Errors::RequestForbidden)}

  it {expect(ConfirmVariantMessage.from_url(["", "api", "v1", "patient", "variant", "123_uuid", "unchecked"])).to eq({:variant_uuid => "123_uuid", :status => "unchecked"})}

  it "can convert to json" do
    testable = get_testable
    json_string = testable.to_json
    expect { JSON.parse(json_string) }.to_not raise_error
  end
end
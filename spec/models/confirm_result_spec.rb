describe ConfirmResult do
  it "can be created" do
    result = ConfirmResult.new
    result.confirmed = true
    result.comments = 'Some Comments'

    expect(result.confirmed).to eq(true)
    expect(result.comments).to eq('Some Comments')
  end

  xit "can convert from json" do
    json = '{"confirm":"true","comment":"Some Comments"}';
    model = ConfirmResult.new.from_json json


  end
end
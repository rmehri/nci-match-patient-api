require 'rails_helper'

RSpec.describe UnknownMessage do

  let (:validator) {UnknownMessage}

  context "initialize correctly" do
    it { expect(validator).to be_truthy }
  end

  context "always throw error" do
    it { expect{validator.new.from_json({}.to_json)}.to raise_error(Errors::ResourceNotFound)}
  end

end
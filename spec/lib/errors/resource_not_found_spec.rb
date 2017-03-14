require 'rails_helper'

RSpec.describe Errors::ResourceNotFound do

  context 'define Unauthorized error and status' do

    it {expect(Errors::ResourceNotFound.new.code).to eq(404)}

    it {expect(Errors::ResourceNotFound.new.to_s).to eq("[404] Errors::ResourceNotFound")}

  end

end
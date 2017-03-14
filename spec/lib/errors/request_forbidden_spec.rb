require 'rails_helper'

RSpec.describe Errors::RequestForbidden do

  context 'define Unauthorized error and status' do

    it {expect(Errors::RequestForbidden.new.code).to eq(403)}

    it {expect(Errors::RequestForbidden.new.to_s).to eq("[403] Errors::RequestForbidden")}

  end

end
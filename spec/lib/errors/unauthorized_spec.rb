require 'rails_helper'

RSpec.describe Errors::Unauthorized do

  context 'define Unauthorized error and status' do

    it {expect(Errors::Unauthorized.new.code).to eq(401)}

    it {expect(Errors::Unauthorized.new.to_s).to eq("[401] Errors::Unauthorized")}

  end

end
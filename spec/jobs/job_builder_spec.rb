require 'rails_helper'

RSpec.describe JobBuilder.new("Random") do


  it{is_expected.to be_truthy}
  it{expect(JobBuilder.new("Random").job).to be_truthy}
  it{expect(JobBuilder.new("Random").job).to be_kind_of(Object)}
  # it{expect(JobBuilder.new("Random").job.respond_to?(:perform_later)).to be_truthy}


end
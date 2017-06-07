require 'rails_helper'

RSpec.describe JobBuilder.new("Random") do


  it{is_expected.to be_truthy}
  it{expect(JobBuilder.new("Random").job).to be_truthy}
  it{expect(JobBuilder.new("Random").job).to be_kind_of(Object)}
  it{expect(JobBuilder.new("Foo::Random").job).to be_kind_of(Object)}

  context "Will create a new job class" do
    let(:job) { JobBuilder }
    it "success" do
      allow(Object).to receive(:const_get).and_raise(NameError)
      expect(job.new("test")).to be_truthy
    end
  end

end
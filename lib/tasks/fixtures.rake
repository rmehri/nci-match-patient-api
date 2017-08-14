Dir.glob(Rails.root.to_s + '/spec/fixtures/*') {|file| load file}

namespace :fixtures do
  [AssayFixture, CogFixture, SpecimenReceivedFixture, SpecimenShippedFixture, VariantReportFixture].each do |fixture|
    type = fixture.to_s.chomp('Fixture')
    desc "List all #{type} fixtures"
    task type.to_sym do
      fixture.constants.each do |sample|
        puts "#{sample.to_s.humanize}:"
        puts JSON.pretty_generate(fixture.const_get(sample))
        puts
      end
    end
  end
end

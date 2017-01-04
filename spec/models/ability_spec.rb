describe Ability, :type => :model do

  it "can create empty object" do
    expect(Ability.new()).to_not be nil
  end

  describe "should handle roles correctly" do
    it "not allow management when blank" do
      expect(Ability.new().can?(:manage, :all)).to eq(false)
    end

    it "allow admin to manage all" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["ADMIN"]}}}).can?(:manage, :all)).to eq(true)
    end

    it "allow PATIENT_MESSAGE_SENDER to access trigger method" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["PATIENT_MESSAGE_SENDER"]}}}).can?(:trigger, :all)).to eq(true)
    end

    it "allow MochaVariantReportReviewer to access variant_report_status method" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["MOCHA_VARIANT_REPORT_REVIEWER"]}}}).can?(:variant_report_status, :all)).to eq(true)
    end

    it "allow AssignmentReportReviewer to access assignment_confirmation method" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["ASSIGNMENT_REPORT_REVIEWER"]}}}).can?(:assignment_confirmation, :all)).to eq(true)
    end

    it "allow System to manage all" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["SYSTEM"]}}}).can?(:manage, :all)).to eq(true)
    end

    it "allow SpecimenMessageSender to access trigger method" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["SPECIMEN_MESSAGE_SENDER"]}}}).can?(:trigger, :all)).to eq(true)
    end

    it "allow AssayMessageSender to access trigger method" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["ASSAY_MESSAGE_SENDER"]}}}).can?(:trigger, :all)).to eq(true)
    end

    it "allow VariantReportSender to access trigger method" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["VARIANT_REPORT_SENDER"]}}}).can?(:trigger, :all)).to eq(true)
    end

    it "allow MdaVariantReportReviewer to access variant_report_status method" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["MDA_VARIANT_REPORT_REVIEWER"]}}}).can?(:variant_report_status, :all)).to eq(true)
    end

  end

  describe "should lock down actions correctly" do

    it "allow PATIENT_MESSAGE_SENDER to not access all method" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["PATIENT_MESSAGE_SENDER"]}}}).can?(:manage, :all)).to eq(false)
    end

    it "allow MochaVariantReportReviewer to access variant_report_status method" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["MOCHA_VARIANT_REPORT_REVIEWER"]}}}).can?(:manage, :all)).to eq(false)
    end

    it "allow AssignmentReportReviewer to access assignment_confirmation method" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["ASSIGNMENT_REPORT_REVIEWER"]}}}).can?(:manage, :all)).to eq(false)
    end

    it "allow SpecimenMessageSender to access trigger method" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["SPECIMEN_MESSAGE_SENDER"]}}}).can?(:manage, :all)).to eq(false)
    end

    it "allow AssayMessageSender to access trigger method" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["ASSAY_MESSAGE_SENDER"]}}}).can?(:manage, :all)).to eq(false)
    end

    it "allow VariantReportSender to access trigger method" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["VARIANT_REPORT_SENDER"]}}}).can?(:manage, :all)).to eq(false)
    end

    it "allow MdaVariantReportReviewer to access variant_report_status method" do
      expect(Ability.new({:app_metadata => {:authorization => {:roles => ["MDA_VARIANT_REPORT_REVIEWER"]}}}).can?(:manage, :all)).to eq(false)
    end

  end

end
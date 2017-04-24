describe Ability, :type => :model do

  it "can create empty object" do
    expect(Ability.new()).to_not be nil
  end

  describe "should handle roles correctly" do
    it "not allow management when blank" do
      expect(Ability.new().can?(:manage, :all)).to eq(false)
    end

    it "allow admin to manage all" do
      expect(Ability.new({:roles => ["ADMIN"]}).can?(:manage, :all)).to eq(true)
    end

    it "allow PATIENT_MESSAGE_SENDER to access trigger method" do
      expect(Ability.new({:roles => ["PATIENT_MESSAGE_SENDER"]}).can?(:trigger, NciMatchPatientModels)).to eq(true)
    end

    it "allow PATIENT_MESSAGE_SENDER to access validate_json_message method" do
      expect(Ability.new({:roles => ["PATIENT_MESSAGE_SENDER"]}).can?(:validate_json_message, TreatmentArmMessage)).to eq(true)
      expect(Ability.new({:roles => ["PATIENT_MESSAGE_SENDER"]}).can?(:validate_json_message, CogMessage)).to eq(true)
    end

    it "allow MochaVariantReportReviewer to access variant_report_status method" do
      expect(Ability.new({:roles => ["MOCHA_VARIANT_REPORT_REVIEWER"]}).can?(:variant_report_status, :MoCha)).to eq(true)
    end

    it "allow AssignmentReportReviewer to access assignment_confirmation method" do
      expect(Ability.new({:roles => ["ASSIGNMENT_REPORT_REVIEWER"]}).can?(:assignment_confirmation, AssignmentStatusMessage)).to eq(true)
      expect(Ability.new({:roles => ["ASSIGNMENT_REPORT_REVIEWER"]}).can?(:assignment_confirmation, NciMatchPatientModels)).to eq(true)
      expect(Ability.new({:roles => ["ASSIGNMENT_REPORT_REVIEWER"]}).can?(:validate_json_message, AssignmentStatusMessage)).to eq(true)
      expect(Ability.new({:roles => ["ASSIGNMENT_REPORT_REVIEWER"]}).can?(:validate_json_message, NciMatchPatientModels)).to eq(true)
    end


    it "allow System to access event and variant report" do
      expect(Ability.new({:roles => ["SYSTEM"]}).can?(:validate_json_message, :Event)).to eq(true)
      expect(Ability.new({:roles => ["SYSTEM"]}).can?(:validate_json_message, VariantReportMessage)).to eq(true)
      expect(Ability.new({:roles => ["SYSTEM"]}).can?(:create, :Event)).to eq(true)
      expect(Ability.new({:roles => ["SYSTEM"]}).can?(:create, VariantReportMessage)).to eq(true)
    end

    it "allow SpecimenMessageSender to access trigger method" do
      expect(Ability.new({:roles => ["SPECIMEN_MESSAGE_SENDER"]}).can?(:trigger, NciMatchPatientModels)).to eq(true)
    end

    it "allow AssayMessageSender to access trigger method" do
      expect(Ability.new({:roles => ["ASSAY_MESSAGE_SENDER"]}).can?(:trigger, NciMatchPatientModels)).to eq(true)
    end

    it "allow VariantReportSender to access variant_report_upload method" do
      expect(Ability.new({:roles => ["MDA_VARIANT_REPORT_SENDER"]}).can?(:variant_report_uploaded, NciMatchPatientModels)).to eq(true)
    end

    it "allow MdaVariantReportReviewer to access variant_report_status method" do
      expect(Ability.new({:roles => ["MDA_VARIANT_REPORT_REVIEWER"]}).can?(:variant_report_status, VariantReportStatusMessage)).to eq(true)
      expect(Ability.new({:roles => ["MDA_VARIANT_REPORT_REVIEWER"]}).can?(:variant_report_status, NciMatchPatientModels)).to eq(true)
      expect(Ability.new({:roles => ["MDA_VARIANT_REPORT_REVIEWER"]}).can?(:validate_json_message, VariantReportStatusMessage)).to eq(true)
      expect(Ability.new({:roles => ["MDA_VARIANT_REPORT_REVIEWER"]}).can?(:validate_json_message, NciMatchPatientModels)).to eq(true)
    end

  end

  describe "should lock down actions correctly" do

    it "allow PATIENT_MESSAGE_SENDER to not access all method" do
      expect(Ability.new({:roles => ["PATIENT_MESSAGE_SENDER"]}).can?(:manage, :all)).to eq(false)
    end

    it "allow MochaVariantReportReviewer to access variant_report_status method" do
      expect(Ability.new({:roles => ["MOCHA_VARIANT_REPORT_REVIEWER"]}).can?(:manage, :all)).to eq(false)
    end

    it "allow AssignmentReportReviewer to access assignment_confirmation method" do
      expect(Ability.new({:roles => ["ASSIGNMENT_REPORT_REVIEWER"]}).can?(:manage, :all)).to eq(false)
    end

    it "allow SpecimenMessageSender to access trigger method" do
      expect(Ability.new({:roles => ["SPECIMEN_MESSAGE_SENDER"]}).can?(:manage, :all)).to eq(false)
    end

    it "allow AssayMessageSender to access trigger method" do
      expect(Ability.new({:roles => ["ASSAY_MESSAGE_SENDER"]}).can?(:manage, :all)).to eq(false)
    end

    it "allow VariantReportSender to access trigger method" do
      expect(Ability.new({:roles => ["VARIANT_REPORT_SENDER"]}).can?(:manage, :all)).to eq(false)
    end

    it "allow MdaVariantReportReviewer to access variant_report_status method" do
      expect(Ability.new({:roles => ["MDA_VARIANT_REPORT_REVIEWER"]}).can?(:manage, :all)).to eq(false)
    end

  end

  # describe "should handle multiple roles" do
  #   it "allow  PATIENT_MESSAGE_SENDER and to manage all" do
  #     expect(Ability.new({:roles => ["MOCHA_VARIANT_REPORT_REVIEWER", "PATIENT_MESSAGE_SENDER"]}).can?(:manage, :all)).to eq(false)
  #     expect(Ability.new({:roles => ["MOCHA_VARIANT_REPORT_REVIEWER", "PATIENT_MESSAGE_SENDER"]}).can?(:assignment_confirmation, :all)).to eq(false)
  #     expect(Ability.new({:roles => ["MOCHA_VARIANT_REPORT_REVIEWER", "PATIENT_MESSAGE_SENDER"]}).can?(:trigger, :all)).to eq(true)
  #     expect(Ability.new({:roles => ["MOCHA_VARIANT_REPORT_REVIEWER", "PATIENT_MESSAGE_SENDER"]}).can?(:variant_report_status, :all)).to eq(true)
  #   end
  # end

end
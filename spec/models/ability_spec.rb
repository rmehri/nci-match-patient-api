describe Ability, :type => :model do

  it "can create empty object" do
    expect(Ability.new()).to_not be nil
  end

  describe "should handle roles correctly" do
    context "not allow management when blank" do
      it{expect(Ability.new().can?(:manage, :all)).to eq(false)}
    end

    context "allow admin to manage all" do
      it{expect(Ability.new({:roles => ["ADMIN"]}).can?(:manage, :all)).to eq(true)}
    end

    context "allow PATIENT_MESSAGE_SENDER to access trigger method" do
      it{expect(Ability.new({:roles => ["PATIENT_MESSAGE_SENDER"]}).can?(:trigger, NciMatchPatientModels)).to eq(true)}
    end

    context "allow PATIENT_MESSAGE_SENDER to access validate_json_message method" do
      it{expect(Ability.new({:roles => ["PATIENT_MESSAGE_SENDER"]}).can?(:validate_json_message, TreatmentArmMessage)).to eq(true)}
      it{expect(Ability.new({:roles => ["PATIENT_MESSAGE_SENDER"]}).can?(:validate_json_message, CogMessage)).to eq(true)}
    end

    context "allow MochaVariantReportReviewer to access variant_report_status method" do
      it{expect(Ability.new({:roles => ["MOCHA_VARIANT_REPORT_REVIEWER"]}).can?(:variant_report_status, :MoCha)).to eq(true)}
    end

    context "allow AssignmentReportReviewer to access assignment_confirmation method" do
      it{expect(Ability.new({:roles => ["ASSIGNMENT_REPORT_REVIEWER"]}).can?(:assignment_confirmation, AssignmentStatusMessage)).to eq(true)}
      it{expect(Ability.new({:roles => ["ASSIGNMENT_REPORT_REVIEWER"]}).can?(:assignment_confirmation, NciMatchPatientModels)).to eq(true)}
      it{expect(Ability.new({:roles => ["ASSIGNMENT_REPORT_REVIEWER"]}).can?(:validate_json_message, AssignmentStatusMessage)).to eq(true)}
      it{expect(Ability.new({:roles => ["ASSIGNMENT_REPORT_REVIEWER"]}).can?(:validate_json_message, NciMatchPatientModels)).to eq(true)}
    end


    context "allow System to access event and variant report" do
      it{expect(Ability.new({:roles => ["SYSTEM"]}).can?(:validate_json_message, :Event)).to eq(true)}
      it{expect(Ability.new({:roles => ["SYSTEM"]}).can?(:validate_json_message, VariantReportMessage)).to eq(true)}
      it{expect(Ability.new({:roles => ["SYSTEM"]}).can?(:create, :Event)).to eq(true)}
      it{expect(Ability.new({:roles => ["SYSTEM"]}).can?(:create, VariantReportMessage)).to eq(true)}
      it{expect(Ability.new({:roles => ["SYSTEM"]}).can?(:variant_report_uploaded, :MDA)).to eq(true)}
      it{expect(Ability.new({:roles => ["SYSTEM"]}).can?(:variant_report_uploaded, :MoCha)).to eq(true)}
      it{expect(Ability.new({:roles => ["SYSTEM"]}).can?(:variant_report_uploaded, :Dartmouth)).to eq(true)}
      it{expect(Ability.new({:roles => ["SYSTEM"]}).can?(:variant_report_uploaded, VariantReportMessage)).to eq(true)}
    end

    context "allow SpecimenMessageSender to access trigger method" do
      it{expect(Ability.new({:roles => ["SPECIMEN_MESSAGE_SENDER"]}).can?(:trigger, NciMatchPatientModels)).to eq(true)}
    end

    context "allow AssayMessageSender to access trigger method" do
      it{expect(Ability.new({:roles => ["ASSAY_MESSAGE_SENDER"]}).can?(:trigger, NciMatchPatientModels)).to eq(true)}
    end

    context "allow VariantReportSender to access variant_report_upload method" do
      it{expect(Ability.new({:roles => ["MDA_VARIANT_REPORT_SENDER"]}).can?(:variant_report_uploaded, NciMatchPatientModels)).to eq(true)}
    end

    context "allow MdaVariantReportReviewer to access variant_report_status method" do
      it{expect(Ability.new({:roles => ["MDA_VARIANT_REPORT_REVIEWER"]}).can?(:variant_report_status, VariantReportStatusMessage)).to eq(true)}
      it{expect(Ability.new({:roles => ["MDA_VARIANT_REPORT_REVIEWER"]}).can?(:variant_report_status, NciMatchPatientModels)).to eq(true)}
      it{expect(Ability.new({:roles => ["MDA_VARIANT_REPORT_REVIEWER"]}).can?(:validate_json_message, VariantReportStatusMessage)).to eq(true)}
      it{expect(Ability.new({:roles => ["MDA_VARIANT_REPORT_REVIEWER"]}).can?(:validate_json_message, NciMatchPatientModels)).to eq(true)}
    end

  end

  describe "should lock down actions correctly" do

    context "allow PATIENT_MESSAGE_SENDER to not access all method" do
      it{expect(Ability.new({:roles => ["PATIENT_MESSAGE_SENDER"]}).can?(:manage, :all)).to eq(false)}
    end

    context "allow MochaVariantReportReviewer to access variant_report_status method" do
      it{expect(Ability.new({:roles => ["MOCHA_VARIANT_REPORT_REVIEWER"]}).can?(:manage, :all)).to eq(false)}
    end

    context "allow AssignmentReportReviewer to access assignment_confirmation method" do
      it{expect(Ability.new({:roles => ["ASSIGNMENT_REPORT_REVIEWER"]}).can?(:manage, :all)).to eq(false)}
    end

    context "allow SpecimenMessageSender to access trigger method" do
      it{expect(Ability.new({:roles => ["SPECIMEN_MESSAGE_SENDER"]}).can?(:manage, :all)).to eq(false)}
    end

    context "allow AssayMessageSender to access trigger method" do
      it{expect(Ability.new({:roles => ["ASSAY_MESSAGE_SENDER"]}).can?(:manage, :all)).to eq(false)}
    end

    context "allow VariantReportSender to access trigger method" do
      it{expect(Ability.new({:roles => ["VARIANT_REPORT_SENDER"]}).can?(:manage, :all)).to eq(false)}
    end

    context "allow MdaVariantReportReviewer to access variant_report_status method" do
      it{expect(Ability.new({:roles => ["MDA_VARIANT_REPORT_REVIEWER"]}).can?(:manage, :all)).to eq(false)}
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
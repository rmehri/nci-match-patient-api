require 'rails_helper'


RSpec.describe ConfirmVariantReportMessage do

  context "handle exceptions" do
    it { expect{ConfirmVariantReportMessage.from_url("")}.to raise_error(ActionController::BadRequest)}
    it { expect{ConfirmVariantReportMessage.from_url(nil)}.to raise_error(ActionController::BadRequest)}
    it { expect{ConfirmVariantReportMessage.from_url({})}.to raise_error(ActionController::BadRequest)}
  end

  context 'convert url' do
    it 'valid' do
      expect(ConfirmVariantReportMessage.from_url(["api", "v1", "patients", "123", "variant_reports", "job1", "confirm"])).to eq({"patient_id"=>"variant_reports", "analysis_id"=>"confirm", "status"=>"CONFIRMED"})
    end

  end


end
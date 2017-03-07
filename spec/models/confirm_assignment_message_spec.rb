RSpec.describe ConfirmAssignmentMessage do

  context "handle exceptions" do
    it { expect{ConfirmAssignmentMessage.from_url("")}.to raise_error(ActionController::BadRequest)}
    it { expect{ConfirmAssignmentMessage.from_url(nil)}.to raise_error(ActionController::BadRequest)}
    it { expect{ConfirmAssignmentMessage.from_url({})}.to raise_error(ActionController::BadRequest)}
  end

  # /api/v1/patients/{patient_id}/assignment_reports/{analysis_id}/confirm

  context 'convert url' do
    it 'valid' do
      expect(ConfirmAssignmentMessage.from_url(["", "api", "v1", "patients", "123", "assignment_report", "job1", "confirm"])).to eq({"patient_id"=>"123", "analysis_id"=>"job1", "status"=>"CONFIRMED", "status_type"=>"ASSIGNMENT"})
    end

  end


end
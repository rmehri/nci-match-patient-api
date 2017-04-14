require 'rails_helper'

RSpec.describe MessageFactory do

  let(:specimen_received) {{:specimen_received => "123", :type => ""}}
  let(:specimen_shipped) {{:specimen_shipped => "test", :type => ""}}
  let(:assay) {{:biomarker => "test"}}
  let(:pathology) {{:type => 'PATHOLOGY_STATUS'}}
  let(:assignment_status) {{:status_type => 'ASSIGNMENT'}}
  let(:variant_report_status_confirmed) {{:status => 'CONFIRMED'}}
  let(:variant_report_status_rejected) {{:status => 'REJECTED'}}
  let(:variant_report) {{:analysis_id => "345"}}
  let(:treatment_arm) {{:treatment_arms => "test"}}

  it{expect(MessageFactory.get_message_type(specimen_received).class).to eq(SpecimenReceivedMessage)}
  it{expect(MessageFactory.get_message_type(specimen_shipped).class).to eq(SpecimenShippedMessage)}
  it{expect(MessageFactory.get_message_type(assay).class).to eq(AssayMessage)}
  it{expect(MessageFactory.get_message_type(pathology).class).to eq(PathologyMessage)}
  it{expect(MessageFactory.get_message_type(assignment_status).class).to eq(AssignmentStatusMessage)}
  it{expect(MessageFactory.get_message_type(variant_report_status_confirmed).class).to eq(VariantReportStatusMessage)}
  it{expect(MessageFactory.get_message_type(variant_report_status_rejected).class).to eq(VariantReportStatusMessage)}
  it{expect(MessageFactory.get_message_type(variant_report).class).to eq(VariantReportMessage)}
  it{expect(MessageFactory.get_message_type(treatment_arm).class).to eq(TreatmentArmMessage)}
  it{expect(MessageFactory.get_message_type({:status => ""}).class).to eq(CogMessage)}

end
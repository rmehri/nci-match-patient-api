require 'rails_helper'

RSpec.describe MessageValidator do

  let(:specimen_received) {{:specimen_received => "123"}}
  let(:specimen_shipped) {{:specimen_shipped => "test"}}
  let(:assay) {{:biomarker => "test"}}
  let(:pathology) {{:type => 'PATHOLOGY_STATUS'}}
  let(:assignment_status) {{:status_type => 'ASSIGNMENT'}}
  let(:variant_report_status_confirmed) {{:status => 'CONFIRMED'}}
  let(:variant_report_status_rejected) {{:status => 'REJECTED'}}
  let(:variant_report) {{:analysis_id => "345"}}
  let(:treatment_arm) {{:treatment_arms => "test"}}

  it{expect(MessageValidator.get_message_type(specimen_received)).to eq("SpecimenReceived")}
  it{expect(MessageValidator.get_message_type(specimen_shipped)).to eq("SpecimenShipped")}
  it{expect(MessageValidator.get_message_type(assay)).to eq("Assay")}
  it{expect(MessageValidator.get_message_type(pathology)).to eq("Pathology")}
  it{expect(MessageValidator.get_message_type(assignment_status)).to eq("AssignmentStatus")}
  it{expect(MessageValidator.get_message_type(variant_report_status_confirmed)).to eq("VariantReportStatus")}
  it{expect(MessageValidator.get_message_type(variant_report_status_rejected)).to eq("VariantReportStatus")}
  it{expect(MessageValidator.get_message_type(variant_report)).to eq("VariantReport")}
  it{expect(MessageValidator.get_message_type(treatment_arm)).to eq("TreatmentArm")}
  it{expect(MessageValidator.get_message_type({})).to eq("Cog")}

end
require 'rails_helper'

RSpec.describe Convert::AssignmentDbModel do


  let(:assignment_converter) {Convert::AssignmentDbModel}

  let(:treatment_assignment_results) { {:treatment_assignment_results => [{:treatment_arm_id => "123",
                                                                          :stratum_id => "Good",
                                                                          :version => Time.now,
                                                                          }]} }

  it {expect{assignment_converter.to_ui(nil, nil)}.to raise_error(NoMethodError)}

  it {expect(assignment_converter.to_ui(treatment_assignment_results, [])).to be_truthy}




end
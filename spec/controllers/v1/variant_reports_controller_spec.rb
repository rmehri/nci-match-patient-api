require 'rails_helper'
require 'factory_girl_rails'
require 'aws-record'

describe V1::VariantReportsController do

  it 'should route correctly' do
    expect(:get => "api/v1/patients/variant_reports?analysis_id=job1&patient_id=3366").to route_to(:controller => "v1/variant_reports",
                                                                                              :action => "index",
                                                                                              :patient_id => "3366",
                                                                                              :analysis_id => "job1")
  end
end
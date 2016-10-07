require 'rails_helper'

describe V1::QcVariantReportsController do

  it 'GET #show' do
    expect(:get => "api/v1/patients/3366/qc_variant_reports/analysis123").to route_to(:controller => "v1/qc_variant_reports",
                                                                       :action => "show",
                                                                                      :patient_id => "3366",
                                                                                      :id => "analysis123")
  end

  it 'should not route' do
    expect { get :index, :patient_id => "3366", :id => "1"}.to raise_error(ActionController::UrlGenerationError)
  end
end
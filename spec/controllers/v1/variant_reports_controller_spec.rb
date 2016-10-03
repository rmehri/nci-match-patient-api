require 'rails_helper'
require 'factory_girl_rails'
require 'aws-record'

describe V1::VariantReportsController do

  it 'GET #show' do
    expect(:get => "api/v1/patients/variant_reports/3366").to route_to(:controller => "v1/variant_reports",
                                                                                                   :action => "show",
                                                                                                   :id => "3366")
  end

  it 'GET #index' do
    expect(:get => "api/v1/patients/variant_reports?analysis_id=job1&patient_id=3366").to route_to(:controller => "v1/variant_reports",
                                                                                                   :action => "index",
                                                                                                   :patient_id => "3366",
                                                                                                   :analysis_id => "job1")
    expect(:get => "api/v1/patients/variant_reports").to route_to(:controller => "v1/variant_reports", :action => "index")
  end

  it 'POST #create' do
    expect { post :create, :id => 1}.to raise_error(ActionController::UrlGenerationError)
  end

  it '#update should throw an route error' do
    expect { patch :update, :id => 1}.to raise_error(ActionController::UrlGenerationError)
  end

  it '#delete should throw an route error' do
    expect { delete :destroy, :id => 1}.to raise_error(ActionController::UrlGenerationError)
  end

end
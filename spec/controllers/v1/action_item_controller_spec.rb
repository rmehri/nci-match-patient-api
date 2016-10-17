describe V1::ActionItemsController, :type => :controller do

  describe "should return valid data model" do
    it "single VariantReport object return" do
      allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([{:molecular_id => "123", :analysis_id => "ABC", :status_date => Date.current}])
      get :index, :patient_id => "123"
      expect(JSON.parse(response.body)).to eq([{"action_type"=>"PENDING_VARIANT_REPORT", "molecular_id"=>"123", "analysis_id"=>"ABC", "created_date"=>Date.current.to_s}])
    end

    it "multiple VariantReport object return" do
      allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([{:molecular_id => "123", :analysis_id => "ABC", :status_date => Date.current},
                                                                                {:molecular_id => "321", :analysis_id => "CBA", :status_date => Date.current}])
      get :index, :patient_id => "123"
      expect(JSON.parse(response.body)).to eq([{"action_type"=>"PENDING_VARIANT_REPORT", "molecular_id"=>"123", "analysis_id"=>"ABC", "created_date"=>Date.current.to_s}, {"action_type"=>"PENDING_VARIANT_REPORT", "molecular_id"=>"321", "analysis_id"=>"CBA", "created_date"=>Date.current.to_s}])
    end

    it "single Assignment object return" do
      allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([{:molecular_id => "123", :analysis_id => "ABC", :status_date => Date.current}])
      get :index, :patient_id => "123"
      expect(JSON.parse(response.body)).to eq([{"action_type"=>"PENDING_ASSIGNMENT", "molecular_id"=>"123", "analysis_id"=>"ABC", "created_date"=>Date.current.to_s}])
    end

    it "multiple Assignment object return" do
      allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([{:molecular_id => "123", :analysis_id => "ABC", :status_date => Date.current},
                                                                                {:molecular_id => "321", :analysis_id => "CBA", :status_date => Date.current}])
      get :index, :patient_id => "123"
      expect(JSON.parse(response.body)).to eq([{"action_type"=>"PENDING_ASSIGNMENT", "molecular_id"=>"123", "analysis_id"=>"ABC", "created_date"=>Date.current.to_s}, {"action_type"=>"PENDING_ASSIGNMENT", "molecular_id"=>"321", "analysis_id"=>"CBA", "created_date"=>Date.current.to_s}])
    end

    it "mix and match multiple" do
      allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([{:molecular_id => "321", :analysis_id => "CBA", :status_date => Date.current}])
      allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([{:molecular_id => "123", :analysis_id => "ABC", :status_date => Date.current}])
      get :index, :patient_id => "123"
      expect(JSON.parse(response.body)).to eq([{"action_type"=>"PENDING_VARIANT_REPORT", "molecular_id"=>"123", "analysis_id"=>"ABC", "created_date"=>Date.current.to_s}, {"action_type"=>"PENDING_ASSIGNMENT", "molecular_id"=>"321", "analysis_id"=>"CBA", "created_date"=>Date.current.to_s}])
    end
  end


  describe "should return empty when errors out" do
    it "have valid http code and empty array return" do
      allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([])
      allow(NciMatchPatientModels::VariantReport).to receive(:scan).and_return([])
      get :index, :patient_id => "random"
      expect(response).to have_http_status(200)
      expect(response.body).to eq("[]")
    end

  end

  it "should have a valid route" do
    expect(:get => "api/v1/patients/1/action_items").to route_to(:controller => "v1/action_items", :action => "index", :patient_id => "1")
  end

end
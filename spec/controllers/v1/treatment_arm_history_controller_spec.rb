describe V1::TreatmentArmHistoryController, :type => :controller do
  describe "should return a valid data set" do
    it "single set" do
      cog_assignment_date = Date.current.to_s
      allow(NciMatchPatientModels::Assignment).to receive(:query).and_return([{:cog_assignment_date => cog_assignment_date ,:step_number => 1.1 , :assignment_date => cog_assignment_date,
                                                                              :selected_treatment_arm => {:treatment_arm_id => "ABC", :version => "123", :stratum_id => "A", :reason => "Just because"}}])
      get :index, params: {patient_id: "123"}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq([{"treatment_arm_id"=>"ABC", "stratum_id"=>"A", "version"=>"123", "step"=>1.1, "assignment_reason"=>"Just because", "date_on_arm"=>cog_assignment_date, "date_off_arm"=>nil}])
    end

    it "multiple set" do
      allow(NciMatchPatientModels::Assignment).to receive(:query).and_return([{:cog_assignment_date => "2017-01-29T17:52:18+00:00" ,:step_number => 2.1 , :assignment_date => Date.current,
                                                                               :selected_treatment_arm => {:treatment_arm_id => "CBA", :version => "321", :stratum_id => "C", :reason => "Just because"}},
                                                                              {:cog_assignment_date => "2017-02-29T17:52:18+00:00" ,:step_number => 1.1 , :assignment_date => Date.current.to_s,
                                                                                :selected_treatment_arm => {:treatment_arm_id => "ABC", :version => "123", :stratum_id => "A", :reason => "Just because"}}
                                                                              ])
      get :index, params: {patient_id: "123"}
      expect(response).to have_http_status(200)
      assignments = JSON.parse(response.body)
      expect(assignments.length).to eq(2)
      expect(assignments[0]["treatment_arm_id"]).to eq("ABC")
    end

    it "multiple set but not those without cog_assignment_date" do
      cog_assignment_date = Date.current
      allow(NciMatchPatientModels::Assignment).to receive(:query).and_return([{:cog_assignment_date => "2017-01-29T17:52:18+00:00", :step_number => 2.1 , :assignment_date => Date.current,
                                                                               :selected_treatment_arm => {:treatment_arm_id => "CBA", :version => "321", :stratum_id => "C", :reason => "Just because"}},
                                                                              {:cog_assignment_date => "2017-01-29T18:52:18+00:00", :step_number => 1.1 , :assignment_date => cog_assignment_date,
                                                                               :selected_treatment_arm => {:treatment_arm_id => "ABC", :version => "123", :stratum_id => "A", :reason => "Just because"}},
                                                                              {:step_number => 1.1 , :assignment_date => cog_assignment_date,
                                                                               :selected_treatment_arm => {:treatment_arm_id => "ABC", :version => "123", :stratum_id => "A", :reason => "Just because"}}
                                                                             ])
      get :index, params: {patient_id: "123"}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq(2)
      expect(JSON.parse(response.body)).to eq([{"treatment_arm_id"=>"ABC", "stratum_id"=>"A", "version"=>"123", "step"=>1.1, "assignment_reason"=>"Just because", "date_on_arm"=>"2017-01-29T18:52:18+00:00", "date_off_arm"=>nil},
                                               {"treatment_arm_id"=>"CBA", "stratum_id"=>"C", "version"=>"321", "step"=>2.1, "assignment_reason"=>"Just because", "date_on_arm"=>"2017-01-29T17:52:18+00:00", "date_off_arm"=>nil}])
    end

    it "multiple set but not those without selected_treatment_arm" do
      cog_assignment_date = Date.current
      allow(NciMatchPatientModels::Assignment).to receive(:query).and_return([{:cog_assignment_date => Date.current ,:step_number => 2.1 , :assignment_date => Date.current,
                                                                               :selected_treatment_arm => {:treatment_arm_id => "CBA", :version => "321", :stratum_id => "C", :reason => "Just because"}},
                                                                              {:cog_assignment_date => cog_assignment_date, :step_number => 1.1 , :assignment_date => cog_assignment_date,
                                                                               :selected_treatment_arm => {:treatment_arm_id => "ABC", :version => "123", :stratum_id => "A", :reason => "Just because"}},
                                                                              {:cog_assignment_date => cog_assignment_date, :step_number => 1.1 , :assignment_date => cog_assignment_date}
                                                                             ])
      get :index, params: {patient_id: "123"}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).length).to eq(2)
      expect(JSON.parse(response.body)).to eq([{"treatment_arm_id"=>"ABC", "stratum_id"=>"A", "version"=>"123", "step"=>1.1, "assignment_reason"=>"Just because", "date_on_arm"=>cog_assignment_date.to_s, "date_off_arm"=>nil}, {"treatment_arm_id"=>"CBA", "stratum_id"=>"C", "version"=>"321", "step"=>2.1, "assignment_reason"=>"Just because", "date_on_arm"=>cog_assignment_date.to_s, "date_off_arm"=>nil}])
    end
  end

  it "should handle empty db return with empty array" do
    allow(NciMatchPatientModels::Assignment).to receive(:scan).and_return([])
    allow(NciMatchPatientModels::Assignment).to receive(:query).and_return([])

    get :index, params: {patient_id: "random"}
    expect(response).to have_http_status(200)
    expect(response.body).to eq("[]")
  end

  it "route to correct controller" do
    expect(:get => "api/v1/patients/1/treatment_arm_history").to route_to(:controller => "v1/treatment_arm_history", :action => "index", :patient_id => "1")
  end
end

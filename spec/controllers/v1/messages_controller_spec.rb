# re-route ServicesController#trigger to multiple methods in MessagesController
# we could remove it in v2
describe 'Services re-route middleware', :type => :request do
  before(:each) do
    # mock admin user
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return({:roles => ["Admin"]})

    # mock valid StateMachine response
    allow(StateMachine).to receive(:validate).and_return('true')

    # mock valid SQS response
    allow(Aws::Sqs::Publisher).to receive(:publish)

    # set extra request params
    headers = {headers: {'Accept' => 'application/json', 'Authorization' => 'token'}} # we dont realy need token as we mock user
    @request_env = headers.merge({as: :json})
  end

  # do not rewrite /api/v1/patients/:patient_id for invalid inputs
  describe "that do not re-route to MessagesController" do
    it "should not re-route for GET" do
      get trigger_path(123) # GET "/api/v1/patients/123" => V1::PatientsController#show
      expect(response).to have_http_status(401)
    end

    it "should return 404 for unknown message type" do
      post trigger_path(123), {params: {}}.merge(@request_env)
      expect(response).to have_http_status(404)
    end
  end

  # rewrite /api/v1/patients/:patient_id to /api/v1/patients/:patient_id/specimen_received
  describe "that re-route to specimen_received path" do
    it "should return 403 for invalid message" do
      post trigger_path(123), {params: SpecimenShippedFixture::INVALID_SAMPLE}.merge(@request_env)
      expect(response).to have_http_status(403) # 403 in v1, in v2 should be 422 when middleware is removed
    end

    it "should re-route SpecimenReceivedMessage input to ServicesControlle#specimen_received" do
      post trigger_path(123), {params: SpecimenShippedFixture::VALID_SAMPLE}.merge(@request_env)
      expect(response).to have_http_status(202)
    end

    it "should strip spaces from valid input" do
      post trigger_path(123), {params: SpecimenShippedFixture::VALID_SAMPLE.merge('key_with_spaces' => ' a b c  ')}.merge(@request_env)
      expect(assigns['message']['key_with_spaces']).to eq('a b c')
    end
  end

  # rewrite /api/v1/patients/:patient_id to /api/v1/patients/:patient_id/specimen_shipped
  describe "that re-route to specimen_shipped path" do
    it "should return 403 for invalid message" do
      post trigger_path(123), {params: SpecimenShippedFixture::INVALID_SAMPLE}.merge(@request_env)
      expect(response).to have_http_status(403)
    end

    it "should re-route SpecimenShippedMessage input to ServicesControlle#specimen_shipped" do
      post trigger_path(123), {params: SpecimenShippedFixture::VALID_SAMPLE}.merge(@request_env)
      expect(response).to have_http_status(202)
    end
  end

  # rewrite /api/v1/patients/:patient_id to /api/v1/patients/:patient_id/assay
  describe "that re-route to assay path" do

    it "should return 403 for invalid message" do
      post trigger_path(123), {params: AssayFixture::INVALID_SAMPLE}.merge(@request_env)
      expect(response).to have_http_status(403)
    end

    it "should return 403 for invalid message with the end date in the past" do
      post trigger_path(123), {params: AssayFixture::INVALID_SAMPLE_WITH_END_DATE_IN_PAST}.merge(@request_env)
      expect(response).to have_http_status(403)
    end

    it "should re-route AssayMessage input to ServicesControlle#assay" do
      post trigger_path(123), {params: AssayFixture::VALID_SAMPLE}.merge(@request_env)
      expect(response).to have_http_status(202)
    end
  end

  # rewrite /api/v1/patients/:patient_id to /api/v1/patients/:patient_id/variant_report
  describe "that re-route to variant_report path" do
    it "should return 403 for invalid message" do
      post trigger_path(123), {params: VariantReportFixture::INVALID_SAMPLE}.merge(@request_env)
      expect(response).to have_http_status(403)
    end

    it "should re-route VariantReportMessage input to ServicesControlle#variant_report and should failed for missing shipment" do
      allow(NciMatchPatientModels::Shipment).to receive(:scan_and_find_by).and_return([]) # no shipments
      post trigger_path(123), {params: VariantReportFixture::INVALID_SAMPLE_WITHOUT_PATIENT_ID}.merge(@request_env)
      expect(response).to have_http_status(403)
    end

    it "should re-route VariantReportMessage input to ServicesControlle#variant_report" do
      allow(NciMatchPatientModels::Shipment).to receive(:scan_and_find_by).and_return([{'patient_id': 1}, {'patient_id': 2}]) # shipments exists
      post trigger_path(123), {params: VariantReportFixture::VALID_SAMPLE}.merge(@request_env)
      expect(response).to have_http_status(202)
    end
  end

  # rewrite /api/v1/patients/:patient_id to /api/v1/patients/:patient_id/cog
  describe "that re-route to cog path" do
    it "should return 403 for invalid REGISTRATION CogMessage input" do
      post trigger_path(123), {params: CogFixture::INVALID_REGISTRATION_SAMPLE}.merge(@request_env)
      expect(response).to have_http_status(403)
    end

    it "should re-route REGISTRATION CogMessage input to ServicesControlle#cog" do
      post trigger_path(123), {params: CogFixture::VALID_REGISTRATION_SAMPLE}.merge(@request_env)
      expect(response).to have_http_status(202)
    end

    it "should re-route VALID_REQUEST_ASSIGNMENT_SAMPLE CogMessage input to ServicesControlle#cog" do
      post trigger_path(123), {params: CogFixture::VALID_REQUEST_ASSIGNMENT_SAMPLE}.merge(@request_env)
      expect(response).to have_http_status(202)
    end

    it "should re-route ON_TREATMENT_ARM CogMessage input to ServicesControlle#cog" do
      post trigger_path(123), {params: CogFixture::VALID_ON_TREATMENT_ARM_SAMPLE}.merge(@request_env)
      expect(response).to have_http_status(202)
    end
  end

end

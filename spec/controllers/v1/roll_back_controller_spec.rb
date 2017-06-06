require 'rails_helper'

# RSpec.describe V1::RollBackController do
#
#   # let(:user) { {:roles => ["Admin"]} }
#   # before(:each) do
#   #   allow(controller).to receive(:current_user).and_return(user)
#   # end
#   #
#   # context 'route to the correct controller' do
#   #
#   #   it {expect(:delete => "api/v1/patients/123/rollback").to route_to(:controller => "v1/roll_back", :action => "destroy",
#   #                                                                          :patient_id => "123")}
#   # end
#   #
#   #
#   # context 'accept a valid request' do
#   #   it 'process a valid rollback_variant_report' do
#   #     message_body = {"status" => "Success", "error" => "some error"}
#   #     allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
#   #     allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
#   #     allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
#   #     allow(HTTParty::Response).to receive(:body).and_return(message_body)
#   #     delete :destroy, params: { :patient_id => "123" }
#   #     expect(response).to have_http_status(204)
#   #   end
#   # end
#   #
#   # context 'rails a invalid request' do
#   #   it 'process a invalid rollback_variant_report' do
#   #     allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
#   #     allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
#   #     allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
#   #     allow(HTTParty::Response).to receive(:code).and_return(500)
#   #     delete :destroy, params: { :patient_id => "123" }
#   #     expect(response).to have_http_status(500)
#   #   end
#   # end
#
# end
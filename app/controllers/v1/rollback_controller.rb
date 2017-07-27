module V1
  class RollbackController < BaseController

    def rollback
      authorize! :rollback, :Admin
      is_valid = HTTParty.get("#{Rails.configuration.environment.fetch('patient_state_api')}/roll_back/roll_back/#{params[:patient_id]}",
                              {:headers => {'X-Request-Id' => request.uuid, 'Authorization' => "Bearer #{token}"}})
      raise Errors::RequestForbidden, "Incoming message failed patient state validation: #{is_valid}" if is_valid.code.to_i > 200
      JobBuilder.new("RollBack::RollbackJob").job.perform_later(convert_request(request.raw_post, params[:patient_id]))
    end

    private
    def convert_request(json, patient_id="")
      unless json.empty?
        message = JSON.parse(json).deep_transform_keys!(&:underscore).symbolize_keys
        message[:patient_id] = patient_id
        message
      end
    end

  end
end
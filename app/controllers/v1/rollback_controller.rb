module V1
  class RollbackController < ApplicationController

    def variant_report
      is_valid = HTTParty.get("#{Rails.configuration.environment.fetch('patient_state_api')}/roll_back/variant_report/#{params[:patient_id]}",
                              {:headers => {'X-Request-Id' => request.uuid, 'Authorization' => "Bearer #{token}"}})
      raise Errors::RequestForbidden, "Incoming message failed patient state validation: #{is_valid}" if is_valid.code.to_i > 200
      JobBuilder.new("RollBack::VariantReportJob").job.perform_later({:patient_id => params[:patient_id]})
    end


    def assignment_report
      is_valid = HTTParty.get("#{Rails.configuration.environment.fetch('patient_state_api')}/roll_back/assignment/#{params[:patient_id]}",
                              {:headers => {'X-Request-Id' => request.uuid, 'Authorization' => "Bearer #{token}"}})
      raise Errors::RequestForbidden, "Incoming message failed patient state validation: #{is_valid}" if is_valid.code.to_i > 200
      JobBuilder.new("RollBack::AssignmentReportJob").job.perform_later({:patient_id => params[:patient_id]})
    end

  end
end
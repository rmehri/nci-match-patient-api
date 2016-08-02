class DashboardController < ApplicationController
  # before_action :authenticate

  # GET /dashboard/pendingVariantReports/:type
  def pending_variant_reports
    begin
      render status: 200, json: '{"test":"test"}'
    rescue => error
      standard_error_message(error.message)
    end
  end

  # GET /dashboard/pendingAssignmentReports
  def pending_assignment_reports
    begin
      render status: 200, json: '{"test":"test"}'
    rescue => error
      standard_error_message(error.message)
    end
  end

end

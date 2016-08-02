class DashboardController < ApplicationController
  # before_action :authenticate

  # GET /dashboard/pendingVariantReports/:type
  def pending_variant_reports
    begin
      type = params[:type].to_s.upcase
      dbm = NciMatchPatientModels::VariantReport.find_by({"status" => "PENDING", "variant_report_type" => type}).collect {|r| r}
      AppLogger.log_debug(self.class.name, "Got #{dbm.length} variant reports of type [#{type}]")
      reports = dbm.map { |x| x.data_to_h }
      render json: reports
    rescue => error
      standard_error_message(error.message)
    end
  end

  # GET /dashboard/pendingAssignmentReports
  def pending_assignment_reports
    begin
      dbm = NciMatchPatientModels::Assignment.find_by({"status" => "PENDING"}).collect {|r| r}
      AppLogger.log_debug(self.class.name, "Got #{dbm.length} assignment reports")
      reports = dbm.map { |x| x.data_to_h }
      render json: reports
    rescue => error
      standard_error_message(error.message)
    end
  end

end

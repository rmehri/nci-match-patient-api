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

  # GET /dashboard/patientStatistics
  def patient_statistics
    begin
      dbm = NciMatchPatientModels::Patient.find_by().collect {|r| r}
      AppLogger.log_debug(self.class.name, "Got #{dbm.length} patients")
      totalPatients = dbm.length
      patientsOnTreatmentArm = dbm.count { |x| x.current_status == 'ON_TREATMENT_ARM' }

      dbm = NciMatchPatientModels::VariantReport.find_by({"status" => "CONFIRMED", "variant_report_type" => "TISSUE"}).collect {|x| x.patient_id}.uniq
      AppLogger.log_debug(self.class.name, "Got #{dbm.length} variant reports with status='CONFIRMED' and variant_report_type='TISSUE'")
      confirmedVrPatients = dbm.length

      stats = { 
        "number_of_patients" => totalPatients.to_s,
        "number_of_patients_on_treatment_arm" => patientsOnTreatmentArm.to_s,
        "number_of_patients_with_confirmed_variant_report" => confirmedVrPatients.to_s
      }

      render json: stats

    rescue => error
      standard_error_message(error.message)
    end
  end

  # GET /dashboard/sequencedAndConfirmedPatients
  def sequenced_and_confirmed_patients
    begin

      report_dbm = NciMatchPatientModels::VariantReport.find_by({"status" => "CONFIRMED", "variant_report_type" => "TISSUE"}).collect {|x| x}.uniq
      AppLogger.log_debug(self.class.name, "Got #{report_dbm.length} variant reports with status='CONFIRMED' and variant_report_type='TISSUE'")

      stats = {
        "patients_with_0_amois" => report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois == 0}.to_s,
        "patients_with_1_amois" => report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois == 1}.to_s,
        "patients_with_2_amois" => report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois == 2}.to_s,
        "patients_with_3_amois" => report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois == 3}.to_s,
        "patients_with_4_amois" => report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois == 4}.to_s,
        "patients_with_5_or_more_amois" =>report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois >= 5}.to_s
      }
      
      render json: stats
    rescue => error
      standard_error_message(error.message)
    end
  end




end

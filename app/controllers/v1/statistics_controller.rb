module V1
  class StatisticsController < ApplicationController
  before_action :authenticate_user

    def patient_statistics
      begin
        patients_assignments = NciMatchPatientModels::Patient.scan({ scan_filter: {'current_status' =>
                                                                   { comparison_operator: "EQ",
                                                                     attribute_value_list: ['ON_TREATMENT_ARM']}},
                                                                     attributes_to_get: ['current_assignment']}).collect { |r| r.to_h.deep_symbolize_keys!.compact }

        render json: {
            #TODO: .all.count???
            number_of_patients: NciMatchPatientModels::Patient.scan_and_find_by({}).length.to_s,
            number_of_patients_on_treatment_arm: patients_assignments.length.to_s,
            number_of_patients_with_confirmed_variant_report: NciMatchPatientModels::VariantReport.scan_and_find_by({"status" => "CONFIRMED", "variant_report_type" => "TISSUE"}).uniq{|vr| vr["patient_id"]}.length.to_s
        }
      rescue => error
        standard_error_message(error)
      end
    end

    def sequenced_and_confirmed_patients
        begin
          report_dbm = NciMatchPatientModels::VariantReport.scan_and_find_by({ "status" => "CONFIRMED", "variant_report_type" => "TISSUE" }).uniq
          AppLogger.log_debug(self.class.name, "Got #{report_dbm.length} variant reports with status='CONFIRMED' and variant_report_type='TISSUE'")

          render json: {
              :amois => [
                  report_dbm.count { |x| x['total_confirmed_amois'].present? && x['total_confirmed_amois'] == 0},
                  report_dbm.count { |x| x['total_confirmed_amois'].present? && x['total_confirmed_amois'] == 1},
                  report_dbm.count { |x| x['total_confirmed_amois'].present? && x['total_confirmed_amois'] == 2},
                  report_dbm.count { |x| x['total_confirmed_amois'].present? && x['total_confirmed_amois'] == 3},
                  report_dbm.count { |x| x['total_confirmed_amois'].present? && x['total_confirmed_amois'] == 4},
                  report_dbm.count { |x| x['total_confirmed_amois'].present? && x['total_confirmed_amois'] >= 5}
              ]
          }
        rescue => error
          standard_error_message(error.message)
        end
    end

  end
end
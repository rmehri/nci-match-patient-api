module V1
  class StatisticsController < ApplicationController
   before_action :authenticate_user

    def patient_statistics
      begin
        patients_assignments = NciMatchPatientModels::Patient.scan({:scan_filter => {'current_status' =>
                                                                  {:comparison_operator => "EQ",
                                                                   :attribute_value_list => ['ON_TREATMENT_ARM']}},
                                             :attributes_to_get => ['current_assignment']}).collect {|r| r.to_h.deep_symbolize_keys!.compact}
        render json: {
            number_of_patients: NciMatchPatientModels::Patient.scan({}).collect{}.length.to_s,
            number_of_patients_on_treatment_arm: patients_assignments.length.to_s,
            number_of_patients_with_confirmed_variant_report: NciMatchPatientModels::VariantReport.find_by({"status" => "CONFIRMED", "variant_report_type" => "TISSUE"}).map(&:patient_id).uniq.collect{}.count.to_s,
            treatment_arm_accrual: build_treatment_arm_accrual(patients_assignments)
        }
      rescue => error
        standard_error_message(error)
      end
    end

    def sequenced_and_confirmed_patients
        begin
          report_dbm = NciMatchPatientModels::VariantReport.find_by({"status" => "CONFIRMED", "variant_report_type" => "TISSUE"}).collect {|x| x.to_h}.uniq
          AppLogger.log_debug(self.class.name, "Got #{report_dbm.length} variant reports with status='CONFIRMED' and variant_report_type='TISSUE'")

          render json: {
              :amois => [
                  report_dbm.count { |x| x[:total_confirmed_amois].present? && x[:total_confirmed_amois] == 0},
                  report_dbm.count { |x| x[:total_confirmed_amois].present? && x[:total_confirmed_amois] == 1},
                  report_dbm.count { |x| x[:total_confirmed_amois].present? && x[:total_confirmed_amois] == 2},
                  report_dbm.count { |x| x[:total_confirmed_amois].present? && x[:total_confirmed_amois] == 3},
                  report_dbm.count { |x| x[:total_confirmed_amois].present? && x[:total_confirmed_amois] == 4},
                  report_dbm.count { |x| x[:total_confirmed_amois].present? && x[:total_confirmed_amois] >= 5}
              ]
          }
        rescue => error
          standard_error_message(error.message)
        end
    end

    private

    def build_treatment_arm_accrual(patients_assignments)
      begin
        treatment_arm_accrual = {}
        patients_assignments.each do |assignment|
          if(assignment.has_key?(:current_assignment))
            if(assignment[:current_assignment].has_key?(:selected_treatment_arm))
              taKey = assignment[:current_assignment][:selected_treatment_arm][:treatment_arm_id] +
                  ' (' + assignment[:current_assignment][:selected_treatment_arm][:stratum_id] +
                  ', ' + assignment[:current_assignment][:selected_treatment_arm][:version] + ')'
              if(treatment_arm_accrual.has_key?(taKey))
                treatment_arm_accrual[taKey][:patients] = treatment_arm_accrual[taKey][:patients] + 1
              else
                treatment_arm_accrual[taKey] = {
                    name: assignment[:current_assignment][:selected_treatment_arm][:treatment_arm_id],
                    stratum_id: assignment[:current_assignment][:selected_treatment_arm][:stratum_id],
                    patients: 1
                }
              end
            end
          end
        end
        treatment_arm_accrual
      rescue => error
        standard_error_message(error)
      end
    end
  end
end
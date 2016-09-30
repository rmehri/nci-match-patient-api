module V1
  class StatisticsController < ApplicationController

    def patient_statistics
      begin
        patient_dbm = NciMatchPatientModels::Patient.find_by().collect {|r| r}
        AppLogger.log_debug(self.class.name, "Got #{patient_dbm.length} patients")
        totalPatients = patient_dbm.length
        patientsOnTreatmentArm_dbm = patient_dbm.select {|x| x.current_status == 'ON_TREATMENT_ARM'}
        patientsOnTreatmentArm = patientsOnTreatmentArm_dbm.length

        treatment_arm_accrual = Hash.new

        patientsOnTreatmentArm_dbm.select { |x| x.respond_to?('current_assignment') }.each do |x|
        # p x.current_assignment['assignment_logic']
          selected = x.current_assignment['assignment_logic'].detect {|a_l| a_l['reasonCategory'] == 'SELECTED'}
          if (selected != nil)
            taKey = selected['treatmentArmName'] + ' (' + selected['treatmentArmStratumId'] + ', ' + selected['treatmentArmVersion'] + ')'
            if (treatment_arm_accrual.has_key?(taKey))
              treatment_arm_accrual[taKey] = treatment_arm_accrual[taKey].patients + 1
            else
              treatment_arm_accrual[taKey] = {
                  "name" => selected['treatmentArmName'],
                  "stratum_id" => selected['treatmentArmStratumId'],
                  "patients" => 1
              }
            end
          end
        end
        variant_report_dbm = NciMatchPatientModels::VariantReport.find_by({"status" => "CONFIRMED", "variant_report_type" => "TISSUE"}).collect {|x| x.patient_id}.uniq
        AppLogger.log_debug(self.class.name, "Got #{variant_report_dbm.length} variant reports with status='CONFIRMED' and variant_report_type='TISSUE'")
        confirmedVrPatients = variant_report_dbm.length

        stats = {
            "number_of_patients" => totalPatients.to_s,
            "number_of_patients_on_treatment_arm" => patientsOnTreatmentArm.to_s,
            "number_of_patients_with_confirmed_variant_report" => confirmedVrPatients.to_s,
            "treatment_arm_accrual" => treatment_arm_accrual
        }

        render json: stats

      rescue => error
        standard_error_message(error.message)
      end
    end

    def sequenced_and_confirmed_patients
        begin
          report_dbm = NciMatchPatientModels::VariantReport.find_by({"status" => "CONFIRMED", "variant_report_type" => "TISSUE"}).collect {|x| x}.uniq
          AppLogger.log_debug(self.class.name, "Got #{report_dbm.length} variant reports with status='CONFIRMED' and variant_report_type='TISSUE'")

          stats = {
              "amois" => [
                  report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois == 0},
                  report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois == 1},
                  report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois == 2},
                  report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois == 3},
                  report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois == 4},
                  report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois >= 5}
              ]
          }

          render json: stats
        rescue => error
          standard_error_message(error.message)
        end
      end
  end
end
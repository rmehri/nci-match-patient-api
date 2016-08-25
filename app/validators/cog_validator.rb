module MessageValidator
  class CogValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks

    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :header, :study_id, :patient_id, :step_number, :registration_date, :status, :internal_use_only,
                  :treatment_arm_id, :treatment_arm_version, :stratum_id, :assignment_date, :message

    def include_correct_module
      case @status.to_sym
        when :REGISTRATION
          class << self; include RegistrationValidator end
        when :ON_TREATMENT_ARM
          class << self; include OnTreatmentArmValidator end
        else
          raise "This is not a message from COG"
      end

    end

   end
end
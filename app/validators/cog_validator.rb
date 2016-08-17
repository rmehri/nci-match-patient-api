module MessageValidator
  class CogValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks

    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :header, :study_id, :patient_id, :step_number, :registration_date, :status, :internal_use_only

    def include_correct_module
      case @status.to_sym
        when :REGISTRATION
          class << self; include RegistrationValidator end
      end

    end

   end
end
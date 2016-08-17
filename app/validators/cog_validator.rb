module MessageValidator
  class CogValidator < AbstractValidator
    include ActiveModel::Validations

    attr_accessor :header, :study_id, :patient_id, :step_number, :registration_date, :status, :internal_use_only

    define_model_callbacks :from_json
    after_from_json :include_correct_module

    #Override
    def from_json(json, include_root=include_root_in_json)
      _run_from_json_callbacks do
        super
      end
    end

    def include_correct_module
      case @status.to_sym
        when :REGISTRATION
          class << self; include RegistrationValidator end
      end

    end

   end
end
module MessageValidator
  class AssignmentStatusValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks

    @message_format = /:status_type=>"ASSIGNMENT"/

    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :patient_id,
                  :molecular_id,
                  :analysis_id,
                  :status,
                  :status_type,
                  :comment,
                  :comment_user

    validates :patient_id, presence: true
    validates :analysis_id, presence: true
    validates :status, presence: true,
              inclusion: {in: %w(CONFIRMED), message: "%{value} is not a valid assignment status value"}
    validates :status_type, presence: true,
              inclusion: {in: %w(ASSIGNMENT), message: "%{value} is not a valid status type value"}
  end
end

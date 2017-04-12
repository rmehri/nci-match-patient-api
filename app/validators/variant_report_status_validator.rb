module MessageValidator
  class VariantReportStatusValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks

    @message_format = /:status=>"CONFIRMED"|"REJECTED"/

    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :patient_id,
                  :analysis_id,
                  :status,
                  :comment,
                  :comment_user

    validates :patient_id, presence: true
    validates :analysis_id, presence: true
    validates :status, presence: true,
              inclusion: {in: %w(CONFIRMED REJECTED), message: "%{value} is not a valid variant report status value"}

  end

end

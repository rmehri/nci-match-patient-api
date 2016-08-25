module MessageValidator
  class AssayValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks

    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :study_id, :patient_id, :surgical_event_id, :biomarker, :reported_date, :ordered_date, :result,
                  :case_number, :type

    validates :study_id, presence: true, inclusion: { in: %w(APEC1621), message: "%{value} is not a valid study_id"} # reapeated so should be its own validation
    validates :patient_id, presence: true
    validates :surgical_event_id, presence: true
    validates :biomarker, presence: true, inclusion: {in: %w(ICCPTENs ICCMLH1s), message: "%{value} is not a valid biomarker"}

    validates :reported_date, presence: true
    validates :ordered_date, presence: true
    validates :result, presence: true, inclusion: {in: %w(POSITIVE NEGATIVE), message: "%{value} is not a valid assay result"}
    validates :case_number, presence: true
    validates :type, inclusion: {in: %w(ASSAY_RESULT_REPORTED), message: "%{value} is not a valid assay message type"}

  end

end
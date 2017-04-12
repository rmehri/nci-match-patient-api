module MessageValidator
  class AssayValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks

    @message_format =  /:biomarker/

    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :study_id, :patient_id, :surgical_event_id, :biomarker, :reported_date, :result,
                  :case_number, :type

    validates :study_id, presence: true, inclusion: { in: %w(APEC1621SC), message: "%{value} is not a valid study_id" } # reapeated so should be its own validation
    validates :patient_id, presence: true
    validates :surgical_event_id, presence: true
    validates :biomarker, presence: true, inclusion: {in: Rails.configuration.assay.collect{ |k, v| if(Date.parse(v["start_date"]) <= Date.current) && (Date.current <= Date.parse(v["end_date"])); k; end},
                                                      message: "%{value} is not a valid biomarker"}

    validates :reported_date, presence: true, date: {on_or_before: lambda {DateTime.current.utc}}
    validates :result, presence: true, inclusion: {in: %w(POSITIVE NEGATIVE INDETERMINATE), message: "%{value} is not a valid assay result"}
    validates :case_number, presence: true
    validates :type, inclusion: {in: %w(RESULT), message: "%{value} is not a valid assay message type"}

  end
end
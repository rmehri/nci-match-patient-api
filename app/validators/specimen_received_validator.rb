module MessageValidator
  class SpecimenReceivedValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks

    define_model_callbacks :from_json
    after_from_json :include_correct_module


    attr_accessor :header, :specimen_received, :patient_id, :type,
                  :study_id, :surgical_event_id, :collected_date, :received_date, :internal_use_only

    validates :header, presence: true
    validates :study_id, presence: true, inclusion: { in: %w(APEC1621), message: "%{value} is not a valid study_id"} # reapeated so should be its own validation
    validates :patient_id, presence: true
    validates :type, presence: true, inclusion: {in: %w(BLOOD TISSUE), message: "%{value} is not a support type"}
    validates :collected_date, presence: true, date: {on_or_before: lambda {DateTime.current.utc} }
    validates :received_date, presence: true, date: {on_or_before: lambda {DateTime.current.utc} }
    validates :internal_use_only, presence: true

    #Override
    def include_correct_module
      p "=========== #{@patient_id}"
      case @type.to_sym
        when :BLOOD
          class << self; include BloodSpecimenReceivedValidator end
        when :TISSUE
          class << self; include TissueSpecimenReceivedValidator end
      end
    end

    #@Override
    def specimen_received=(value)
      @specimen_received = value
      unless value.blank?
        value.deep_transform_keys!(&:underscore).symbolize_keys!
        @patient_id = value[:patient_id]
        @study_id = value[:study_id]
        @surgical_event_id = value[:surgical_event_id]
        @type = value[:type]
        @collected_date = value[:collection_dttm]
        @received_date = value[:received_dttm]
        @internal_use_only = value[:internal_use_only]
      end
    end

  end
end
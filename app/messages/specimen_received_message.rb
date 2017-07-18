class SpecimenReceivedMessage < AbstractMessage
    include MessageValidator::SpecimenReceivedValidator

    @message_format = /:specimen_received/

    attr_accessor :header, :specimen_received, :patient_id, :type,
                  :study_id, :surgical_event_id, :collected_date, :received_date, :internal_use_only

    # Override
    def include_correct_module
      case @type&.to_sym # missing nested keys are nil
        when :BLOOD
          class << self; include BloodSpecimenReceivedValidator end
        when :TISSUE
          class << self; include TissueSpecimenReceivedValidator end
      end
    end

    # Override
    def specimen_received=(value)
      @specimen_received = value
      unless value.blank?
        value.deep_transform_keys!(&:underscore).symbolize_keys!
        @patient_id = value[:patient_id]
        @study_id = value[:study_id]
        @surgical_event_id = value[:surgical_event_id]
        @type = value[:type]
        @collected_date = value[:collection_dt]
        @received_date = value[:received_dttm]
      end
    end
end

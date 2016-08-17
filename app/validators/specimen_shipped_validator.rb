module MessageValidator
  class SpecimenShippedValidator

    attr_accessor :header, :msg_guid, :msg_dttm, :specimen_shipped, :patient_id, :type,
                  :study_id, :surgical_event_id, :internal_use_only,
                  :molecular_id, :molecular_dna_id, :molecular_cdna_id, :carrier, :tracking_id, :shipped_ts


    validates :header, presence: true
    validates :study_id, presence: true, inclusion: { in: %w(APEC1621), message: "%{value} is not a valid study_id"} # reapeated so should be its own validation
    validates :patient_id, presence: true
    validates :type, presence: true, inclusion: {in: %w(TISSUE_DNA_AND_CDNA SLIDE), message: "%{value} is not a support type"}
    validates :surgical_event_id, presence: true
    validates :molecular_id, presence: true
    validates :molecular_dna_id, presence: true
    validates :molecular_cdna_id, presence: true
    validates :carrier, presence: true
    validates :tracking_id, presence: true
    validates :shipped_ts, presence: true
    validates :internal_use_only, presence: true

    #@Override
    def specimen_shipped=(value)
      @specimen_shipped = value
      if !value.blank?
        value.deep_transform_keys!(&:underscore).symbolize_keys!
        @patient_id = value[:patient_id]
        @study_id = value[:study_id]
        @surgical_event_id = value[:surgical_event_id]
        @molecular_id = value[:molecular_id]
        @molecular_dna_id = value[:molecular_dna_id]
        @molecular_cdna_id = value[:molecular_cdna_id]
        @type = value[:type]
        @carrier = value[:carrier]
        @tracking_id = value[:tracking_id]
        @shipped_ts = value[:shipped_ts]
        @internal_use_only = value[:internal_use_only]
      end
      define_module
    end
  end
end
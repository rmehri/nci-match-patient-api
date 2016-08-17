module MessageValidator
  class SpecimenShippedValidator < AbstractValidator
    include ActiveModel::Validations
    include ActiveModel::Callbacks

    define_model_callbacks :from_json
    after_from_json :include_correct_module

    attr_accessor :header, :msg_guid, :msg_dttm, :specimen_shipped, :patient_id, :type,
                  :study_id, :surgical_event_id, :internal_use_only, :slide_barcode, :destination,
                  :molecular_id, :molecular_dna_id, :molecular_cdna_id, :carrier, :tracking_id, :shipped_dttm


    validates :header, presence: true
    validates :study_id, presence: true, inclusion: { in: %w(APEC1621), message: "%{value} is not a valid study_id"} # reapeated so should be its own validation
    validates :patient_id, presence: true
    validates :type, presence: true, inclusion: {in: %w(TISSUE_DNA_AND_CDNA SLIDE BLOOD_DNA), message: "%{value} is not a support type"}
    validates :molecular_id, presence: true
    validates :carrier, presence: true
    validates :tracking_id, presence: true
    validates :shipped_dttm, presence: true, date: {on_or_before: Date.current}
    validates :destination, presence: true
    validates :internal_use_only, presence: true

    #Override
    def include_correct_module
      case @type.to_sym
        when :BLOOD_DNA
          class << self; include BloodSpecimenShippedValidator end
        when :TISSUE_DNA_AND_CDNA
          class << self; include TissueSpecimenShippedValidator end
        when :SLIDE
          class << self; include SlideSpecimenShippedValidator end
      end
    end

    #@Override
    def specimen_shipped=(value)
      @specimen_shipped = value
      unless value.blank?
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
        @shipped_dttm = value[:shipped_dttm]
        @destination = value[:destination]
        @internal_use_only = value[:internal_use_only]
      end
    end
  end
end
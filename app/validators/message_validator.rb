module MessageValidator

  autoload :SpecimenReceivedValidator,     'specimen_received_validator'
  autoload :SpecimenShippedValidator,      'specimen_shipped_validator'
  autoload :CogValidator,                  'cog_validator'
  autoload :AssayValidator,                'assay_validator'
  autoload :PathologyValidator,            'pathology_validator'

  class << self
    cattr_reader :schema
  end

  def self.get_message_type(message_json)
    type = 'UNKNOWN'

    message = JSON.parse(message_json)
    message.deep_transform_keys!(&:underscore).symbolize_keys!

    if (!message[:status].nil? && message[:status] == 'REGISTRATION')
      type = "Cog"
    elsif (!message[:specimen_received].nil?)
      type = "SpecimenReceived"
    elsif (!message[:specimen_shipped].nil?)
      type = "SpecimenShipped"
    elsif (!message[:biomarker].nil?)
      type = "Assay"
    elsif (!message[:message].nil? && message[:message].start_with?("PATHOLOGY"))
      type = "Pathology"
    end

    type
  end

end
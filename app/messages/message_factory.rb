module MessageFactory

  # TODO: we construct only few of these, see messages controller spec
  def self.get_message_type(message)
    case message.to_s
      when SpecimenReceivedMessage.message_format
        type = SpecimenReceivedMessage
      when SpecimenShippedMessage.message_format
        type = SpecimenShippedMessage
      when AssayMessage.message_format
        type = AssayMessage
      when PathologyMessage.message_format
        type = PathologyMessage
      when AssignmentStatusMessage.message_format
        type = AssignmentStatusMessage
      when VariantReportStatusMessage.message_format
        type = VariantReportStatusMessage
      when VariantReportMessage.message_format
        type = VariantReportMessage
      when TreatmentArmMessage.message_format
        type = TreatmentArmMessage
      when CogMessage.message_format
        type = CogMessage
      else
        type = UnknownMessage
    end
    return type.new.from_json(message.to_json)
  end

end

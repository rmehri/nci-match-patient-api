
class TreatmentArmMessage < AbstractMessage
  include MessageValidator::TreatmentArmsValidator

  @message_format = /:treatment_arms/

  attr_accessor :treatment_arms

end
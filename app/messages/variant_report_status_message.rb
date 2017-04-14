
class VariantReportStatusMessage < AbstractMessage
  include MessageValidator::VariantReportStatusValidator

  @message_format = /:status=>"CONFIRMED"|"REJECTED"/

  attr_accessor :patient_id,
                :analysis_id,
                :status,
                :comment,
                :comment_user

end
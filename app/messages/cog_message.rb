class CogMessage < AbstractMessage
  include MessageValidator::CogValidator

  @message_format = /:status=>"REGISTRATION"|"ON_TREATMENT_ARM"|"OFF_STUDY"|"OFF_STUDY_BIOPSY_EXPIRED"|"REQUEST_ASSIGNMENT"|"REQUEST_NO_ASSIGNMENT"/

  attr_accessor :header, :study_id, :patient_id, :step_number, :registration_date, :status, :status_date, :internal_use_only,
                :treatment_arm_id, :treatment_arm_version, :stratum_id, :assignment_date, :message, :rebiopsy

  validates :status_date, presence: true, date: { on_or_before: lambda {DateTime.current.utc}, message: "status_date can not be later than current date"}

  def include_correct_module
    case @status.to_sym
      when :REGISTRATION
        class << self; include RegistrationValidator; end
      when :ON_TREATMENT_ARM
        class << self; include OnTreatmentArmValidator; end
      when :OFF_STUDY, :OFF_STUDY_BIOPSY_EXPIRED
        class << self; include OffStudyValidator; end
      when :REQUEST_ASSIGNMENT, :REQUEST_NO_ASSIGNMENT
        class << self; include RequestAssignmentValidator; end
      else
        p "Cog message status is: #{@status}"
    end
  end
end
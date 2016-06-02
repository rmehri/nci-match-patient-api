module Convert

  class PatientDbModel
    def self.to_ui_model(dbModel)
      uiModel = PatientUiModel.new

      uiModel.patient_id           = dbModel.patient_id
      uiModel.registration_date    = dbModel.registration_date
      uiModel.study_id             = dbModel.study_id
      uiModel.gender               = dbModel.gender
      uiModel.ethnicity            = dbModel.ethnicity
      uiModel.races                = dbModel.races
      uiModel.current_step_number  = dbModel.current_step_number
      uiModel.current_assignment   = dbModel.current_assignment
      uiModel.current_status       = dbModel.current_status

      uiModel.disease              = dbModel.disease
      uiModel.prior_drugs          = dbModel.prior_drugs
      uiModel.documents            = dbModel.documents

      return uiModel
    end
  end

end

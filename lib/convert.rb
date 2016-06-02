module Convert

  class PatientDbModel
    def self.to_ui_model(patient_dbm, events_dbm, biopsies_dbm, specimens_dbm, variantReports_dbm, variants_dbm)
      uiModel = PatientUiModel.new

      uiModel.patient_id           = patient_dbm.patient_id
      uiModel.registration_date    = patient_dbm.registration_date
      uiModel.study_id             = patient_dbm.study_id
      uiModel.gender               = patient_dbm.gender
      uiModel.ethnicity            = patient_dbm.ethnicity
      uiModel.races                = patient_dbm.races
      uiModel.current_step_number  = patient_dbm.current_step_number
      uiModel.current_assignment   = patient_dbm.current_assignment
      uiModel.current_status       = patient_dbm.current_status

      uiModel.disease              = patient_dbm.disease
      uiModel.prior_drugs          = patient_dbm.prior_drugs
      uiModel.documents            = patient_dbm.documents

      if biopsies_dbm != nil
        uiModel.biopsy_selectors = biopsies_dbm.map { |b_dbm|
          to_ui_biopsy_selector b_dbm
        }

        uiModel.biopsy = to_ui_biopsy biopsies_dbm[biopsies_dbm.size - 1]
      end

      return uiModel
    end

    private

    def self.to_ui_biopsy_selector(dbm)
      {"text" => dbm.type, "biopsy_sequence_number" => dbm.biopsy_sequence_number}
    end

    def self.to_ui_biopsy(dbm)
      {
          "patient_id"             => dbm.patient_id            ,
          "biopsy_sequence_number" => dbm.biopsy_sequence_number,
          "biopsy_received_date"   => dbm.biopsy_received_date  ,
          "cg_collected_date"      => dbm.cg_collected_date     ,
          "cg_id"                  => dbm.cg_id                 ,
          "study_id"               => dbm.study_id              ,
          "type"                   => dbm.type
      }
    end

  end

end

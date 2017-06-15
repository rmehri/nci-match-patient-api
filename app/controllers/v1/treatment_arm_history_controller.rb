module V1
  class TreatmentArmHistoryController < BaseController
    before_action :set_resource, only: [:index]

    def index
      render json: instance_variable_get("@#{resource_name}")
    end

    private

    def resource_name
      @resource_name = "assignment"
    end

    def set_resource(_resource = {})
      resources = NciMatchPatientModels::Assignment.query_by_patient_id(params.require(:patient_id), false)
      resources = resources.collect{|record| build_treatment_arms_history_model(record.to_h.compact) }
      resources = resources.select{|record| !record.blank?}.sort_by{ |assignment| assignment[:date_on_arm]}.reverse
      instance_variable_set("@#{resource_name}", resources)
    end

    def build_treatment_arms_history_model(record = {})
      record.deep_symbolize_keys!
      return {} if record[:selected_treatment_arm].blank? || record[:cog_assignment_date].blank?
      {
          :treatment_arm_id => record[:selected_treatment_arm][:treatment_arm_id],
          :stratum_id => record[:selected_treatment_arm][:stratum_id],
          :version => record[:selected_treatment_arm][:version],
          :step => record[:step_number],
          :assignment_reason => record[:selected_treatment_arm][:reason],
          :date_on_arm => record[:cog_assignment_date],
          :date_off_arm => record[:off_arm_date]
      }
    end

  end
end
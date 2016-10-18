module V1
  class TreatmentArmHistoryController < BaseController
    before_action :set_resource, only: [:index]

    def index
      render json: instance_variable_get("@#{resource_name}")
    end


    private
    def set_resource(resources = {})
      resources = NciMatchPatientModels::Assignment.scan(resource_params).collect{|record| build_treatment_arms_history_model(record.to_h.compact) }
      instance_variable_set("@#{resource_name}", resources)
    end

    def treatment_arm_history_params
      build_query({:patient_id => params.require(:patient_id),
                   :projection => ['selected_treatment_arm', 'step_number', 'cog_assignment_date'],
                   :attribute => ['selected_treatment_arm', 'step_number', 'cog_assignment_date']})
    end

    def build_treatment_arms_history_model(record = {})
      record.deep_symbolize_keys!
      {
          :treatment_arm_id => record[:selected_treatment_arm][:treatment_arm_id],
          :stratum_id => record[:selected_treatment_arm][:stratum_id],
          :version => record[:selected_treatment_arm][:version],
          :step => record[:step_number],
          :assignment_reason => record[:selected_treatment_arm][:reason],
          :assignment_date => record[:cog_assignment_date]
      }
    end

  end
end
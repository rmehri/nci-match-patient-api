module V1
  class PatientsController < BaseController
    include PatientsDoc

    resource_description do
      name 'Patient'
    end

    def index
      plural_resource_name = "@#{resource_name.pluralize}"
      resources = resource_class.scan(query_params).collect { |data| data.to_h.compact }

      patients = []
      resources.each do | patient |
        patient = format_fields(patient)
        patients.push(patient)
      end

      instance_variable_set(plural_resource_name, patients)
      render json: instance_variable_get(plural_resource_name)
    end

    def show
      items = resource_class.query_secondary_index("current_status-index", {hash_key: "current_status", search_value: "OFF_STUDY"})
      # items = resource_class.query({table_name: 'patients',
      #                        index_name: 'current_status-index',
      #                        select: 'ALL_PROJECTED_ATTRIBUTES',
      #                              key_condition_expression: 'current_status = :current_status',
      #                              expression_attribute_values: {
      #                                  ':current_status' => 'OFF_STUDY'
      #                              }})
      p items.count
      patient = get_resource.compact
      render json: format_fields(patient)
    end

    private

    def patients_params
      params.require(:id)
      build_show_query(params.except(:action, :controller), :patient_id)
    end

    def format_fields(patient)
      patient.deep_symbolize_keys!
      if (patient[:current_status] == "PENDING_CONFIRMATION" ||
          patient[:current_status] == "PENDING_APPROVAL" ||
          patient[:current_status] == "ON_TREATMENT_ARM")
        unless patient[:current_assignment].blank?
          unless patient[:current_assignment][:selected_treatment_arm].blank?
            unless patient[:current_assignment][:report_status] == "COMPASSIONATE_CARE"
              selected_ta = patient[:current_assignment][:selected_treatment_arm]
              selected_ta[:treatment_arm_title] = ApplicationHelper.format_treatment_arm_title(selected_ta)

              patient[:current_assignment] = selected_ta
            end

          end

        end
      end

      unless patient[:diseases].blank?
        patient[:disease_name] = ApplicationHelper.format_disease_names(patient[:diseases])
      end
      patient
    end
  end
end

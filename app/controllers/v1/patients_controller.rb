module V1
  class PatientsController < BaseController

    def index
      begin
        plural_resource_name = "@#{resource_name.pluralize}"
        resources = resource_class.scan(query_params).collect { |data| data.to_h.compact }

        patients = []
        resources.each do | patient |
          patient = format_fields(patient)
          patients.push(patient)
        end

        instance_variable_set(plural_resource_name, patients)
        render json: instance_variable_get(plural_resource_name)
      rescue Aws::DynamoDB::Errors::ServiceError => error
        standard_error_message(error)
      end
    end

    def show
      begin
        patient = get_resource.first
        return standard_error_message("Resource not found", 404) if patient.blank?

        render json: format_fields(patient)
      rescue Aws::DynamoDB::Errors::ServiceError => error
        standard_error_message(error)
      end
    end

    private
    def patients_params
      params.require(:id)
      params[:patient_id] = params.delete(:id)
      build_query(params.except(:action, :controller))
    end

    def format_fields(patient)
      patient.deep_symbolize_keys!
      if (!patient[:current_assignment].blank?)
        if !patient[:current_assignment][:selected_treatment_arm].blank?
          selected_ta = patient[:current_assignment][:selected_treatment_arm]
          selected_ta[:treatment_arm_title] = ApplicationHelper.format_treatment_arm_title(selected_ta)

          patient[:current_assignment] = selected_ta
        end

      end

      if (!patient[:diseases].blank?)
        patient[:disease_name] = ApplicationHelper.format_disease_names(patient[:diseases])
      end

      patient
    end

  end
end
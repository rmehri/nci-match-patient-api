module V1
  class PatientsController < BaseController

    def index
      begin
        plural_resource_name = "@#{resource_name.pluralize}"
        resources = resource_class.scan(query_params).collect { |data| data.to_h.compact }

        patients = []
        resources.each do | patient |
          patient.deep_symbolize_keys!
          if (!patient[:current_assignment].blank?)
            if !patient[:current_assignment][:selected_treatment_arm].blank?
              patient[:treatment_arm_title] = format_treatment_arm_title(patient[:current_assignment][:selected_treatment_arm])
            end

            patient.delete(:current_assignment)
          end

          if (!patient[:diseases].blank?)
            patient[:disease_name] = format_disease_names(patient[:diseases])
            patient.delete(:diseases)
          end

          patients.push(patient)
        end

        instance_variable_set(plural_resource_name, patients)
        render json: instance_variable_get(plural_resource_name)
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

    def format_treatment_arm_title(treatment_arm_hash)
      "#{treatment_arm_hash[:treatment_arm_id]} (#{treatment_arm_hash[:stratum_id]}, #{treatment_arm_hash[:version]})"
    end

    def format_disease_names(diseases)
      disease_names = ""
      diseases.each do | disease |
        disease_names = if disease_names.length == 0 then disease[:disease_name] else "#{disease_names}, #{disease[:disease_name]}" end
      end

      disease_names
    end
  end
end
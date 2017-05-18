module V1
  class PatientsController < BaseController
    include PatientsDoc

    resource_description do
      name 'Patients'
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
      patient = get_resource.compact
      render json: format_fields(patient)
    end

    def health_check
      result = {}
      begin
        dynamodb = Aws::DynamoDB::Client.new(endpoint: Rails.configuration.environment.fetch('aws_dynamo_endpoint'),
                                             access_key_id: Rails.application.secrets.aws_access_key_id,
                                             secret_access_key: Rails.application.secrets.aws_secret_access_key,
                                             region: Rails.configuration.environment.fetch('aws_region'),
                                             retry_limit: 0)
        result['dynamodb_connection'] = 'Successfull' if dynamodb.list_tables.class == Seahorse::Client::Response
      rescue => error
        Rails.logger.info("Connection to DynamoDB failed because of #{error.message}")
        result['dynamodb_connection'] = 'Unsuccessfull'
      end
      result['queue_name'] = Rails.configuration.environment.fetch('queue_name')
      begin
        region = Rails.configuration.environment.fetch('aws_region')
        end_point = "https://sqs.#{region}.amazonaws.com"
        queue_name = Rails.configuration.environment.fetch('queue_name')
        access_key = Rails.application.secrets.aws_access_key_id
        aws_secret_access_key = Rails.application.secrets.aws_secret_access_key
        creds = Aws::Credentials.new(access_key, aws_secret_access_key)
        client = Aws::SQS::Client.new(endpoint: end_point, region: region, credentials: creds)
        _queue = Shoryuken::Queue.new(client, queue_name)
        result['queue_connection'] = 'Successfull'
      rescue => error
        Rails.logger.info("Connection to SQS failed because of #{error.message}")
        result['queue_connection'] = 'Unsuccessfull'
      end
      render json: result
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

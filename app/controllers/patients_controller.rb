class PatientsController < ApplicationController
  # before_action :authenticate

  # GET /patients
  def patient_list
    begin
      render json: NciMatchPatientModels::Patient.scan({}).collect { |data| data.to_h }
    rescue => error
      standard_error_message(error)
    end
  end

  # GET /patients/1/timeline
  def timeline
    render_event_patient_data [params[:patientid]]
  end

  # GET /patients/1
  def patient
    render_patient_data [params[:patientid]]
  end

  # GET /patients/:patientid/sampleHistory/:sampleid
  def sample
    render status: 200, json: '{"test":"test"}'
  end

  # GET /patients/:patientid/qcVariantReport/:sampleid/:type
  def qc_variant_report
    render status: 200, json: '{"test":"test"}'
  end

  # POST /registration
  def registration
    Rails.logger.info "Registrating patient..."
    process_message("Cog")
  end

  #POST
  def specimen_shipped
    process_message("SpecimenShipped")
  end

  # POST /specimenReceipt
  def specimen_received
    process_message("SpecimenReceived")
  end

  # POST /variantResult
  def assay_result
    process_message("Assay")
  end

  # POST /variantResult
  def variant_result
    process_message
  end

  # POST /pathologyStatus
  def pathology_status
    process_message("Pathology")
  end

  # POST /patients/:patientid/sampleFile
  def sample_file
    render status: 200, json: '{"test":"test"}'
  end

  # PUT /patients/:patientid/variantStatus
  def variant_status
    render status: 200, json: '{"test":"test"}'
  end

  # PUT /patients/:patientid/variantReportStatus
  def variant_report_status
    render status: 200, json: '{"test":"test"}'
  end

  # POST /patients/:patientid/assignmentConfirmation
  def assignment_confirmation
    render status: 200, json: '{"test":"test"}'
  end

  # POST /patientStatus
  def patient_status
    process_message
  end

  # GET /patients/:patientid/documents
  def document_list
    render status: 200, json: '{"test":"test"}'
  end

  # GET /patients/:patientid/documents/:documentid
  def document
    render status: 200, json: '{"test":"test"}'
  end

  # POST /patients/:patientid/documents
  def new_document
    render status: 200, json: '{"test":"test"}'
  end


  private

  def scan(record, patientid)
    begin
      record.scan(
          :scan_filter => {
              "patient_id" => {
                  :comparison_operator => "EQ",
                  :attribute_value_list => patientid
              }
          }
      )
    rescue Aws::DynamoDB::Errors::ResourceNotFoundException => error1
      p error1
      standard_error_message(error1)
    rescue => error2
      p error2
      raise
    end
  end

  def render_event_patient_data(patientid)
    begin
      json_data = scan NciMatchPatientModels::Event, patientid
      render json: json_data
    rescue => error
      standard_error_message(error)
    end
  end

  def render_patient_data(patientid)
    begin

      patient = NciMatchPatientModels::Patient.query_patient_by_id(patientid[0])
      raise "Unable to find patient #{patientid[0]}" if patient.nil?
      Rails.logger.debug "Got patient: #{patient.to_json}"

      specimens = NciMatchPatientModels::Specimen.query_specimens_by_patient_id(patientid[0], 'false')
      Rails.logger.debug "Got Specimen: #{specimens.to_json}"

      events = NciMatchPatientModels::Event.query_events_by_id(patientid[0], 'false')
      Rails.logger.debug "Got events: #{events.to_json}"
      uim = Convert::PatientDbModel.to_ui_model patient, events, nil, nil, specimens
      # uim = Convert::PatientDbModel.to_ui_model patient_dbm, events_dbm, variant_reports_dbm, variants_dbm, specimens_dbm

      uim
      render json: uim

    rescue => error
      standard_error_message(error)
    end
  end

  def valid_test_message
    {:valid => true}
  end

  def invalid_test_message
    {:valid => false}
  end

  def process_message(*message_type)
    if validate_and_queue(message_type)
      render_validation_success
    else
      render_validation_failure;
    end
  end

  def render_validation_success
    render status: 200, json: {:status => "Success"}
  end

  def render_validation_failure
    render status: 400, json: {:status => "Failure", :message => "Validation failed. Please check all required fields are present"}
  end

  def get_post_data
    json_data = JSON.parse(request.raw_post)
    Rails.logger.debug "Got message: #{json_data.to_json}"
    json_data.deep_transform_keys!(&:underscore).symbolize_keys!
    json_data
  end

  def validate_and_queue(*message_type)

    Rails.logger.debug "Message_type val: #{message_type}"

    message = get_post_data
    message_type = {message_type[-1][-1] => message}
    Rails.logger.debug "Message type: #{message_type}"

    res = StateMachine.validate(message_type)
    Rails.logger.debug "Response from StateMachine: #{res}"
    if res == "true"
      queue_name = ENV['queue_name']
      Rails.logger.debug "Patient API publishing to queue: #{queue_name}..."
      Aws::Sqs::Publisher.publish(message, queue_name)
      return true
    else
      return false
    end
  end
end

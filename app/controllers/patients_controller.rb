class PatientsController < ApplicationController
  # before_action :authenticate

  # GET /patients
  def patient_list
    begin
      render json: NciMatchPatientModels::Patient.scan({}).collect { |data| data.to_h }
    rescue => error
      standard_error_message(error.message)
    end
  end


  # GET /timeline
  def timeline
    render_event_data
  end

  # GET /patients/1/timeline
  def timeline
    render_event_patient_data [params[:patientid]]
  end

  # GET /patients/1
  def patient
    render_patient_data params[:patientid]
  end

  # GET /patients/:patientid/sampleHistory/:sampleid
  def sample
    render status: 200, json: '{"test":"test"}'
  end

  # GET /patients/:patientid/qcVariantReport/:sampleid/:type
  def qc_variant_report
    render status: 200, json: '{"test":"test"}'
  end

  # POST /patients/:patientid/sampleFile
  def sample_file
    render status: 200, json: '{"test":"test"}'
  end

  # PUT /patients/:patientid/variantStatus
  def variant_status
    begin
      input_data = get_post_data
      response_json = PatientProcessor.run_service("/confirm_variant", input_data)

      AppLogger.log(self.class.name, "\nResponse from Patient Process: #{response_json}")
      standard_success_message(JSON.parse(response_json)['message'])

    rescue => error
      standard_error_message(error.message)
    end

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

  def render_event_data()
    begin
      events_dbm = NciMatchPatientModels::Event.scan({limit: 10}).collect {|r| r}
      AppLogger.log_debug(self.class.name, "Got 10 events for dashboard") if !events_dbm.nil?

      events = events_dbm.map { |e_dbm| e_dbm.data_to_h }
      render json: events
    rescue => error
      standard_error_message(error.message)
    end
  end

  def render_event_patient_data(patientid)
    begin
      events_dbm = NciMatchPatientModels::Event.query_events_by_id(patientid[0], false).collect {|r| r}
      AppLogger.log_debug(self.class.name, "Got #{events_dbm.count} events for patient #{patientid[0]}") if !events_dbm.nil?

      events = events_dbm.map { |e_dbm| e_dbm.data_to_h }
      render json: events
    rescue => error
      standard_error_message(error.message)
    end
  end

  def render_patient_data(patient_id)
    begin

      patient_dbm = NciMatchPatientModels::Patient.query_patient_by_id(patient_id)
      raise "Unable to find patient #{patient_id}" if patient_dbm.nil?

      AppLogger.log_debug(self.class.name, "Found patient [#{patient_id}]")

      specimens_dbm = NciMatchPatientModels::Specimen.query_specimens_by_patient_id(patient_id, false).collect {|r| r}
      AppLogger.log_debug(self.class.name, "Got #{specimens_dbm.length} specimens for patient [#{patient_id}]")

      variant_reports_dbm = get_variant_reports(patient_id)
      variants_dbm = get_variants_for_reports(variant_reports_dbm)

      uim = Convert::PatientDbModel.to_ui_model patient_dbm, variant_reports_dbm, variants_dbm, specimens_dbm
      render json: uim

    rescue => error
      standard_error_message(error.message)
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
    AppLogger.log_debug(self.class.name, "Patient API received message: #{json_data.to_json}")
    json_data.deep_transform_keys!(&:underscore).symbolize_keys!
    json_data
  end

  def validate_and_queue(*message_type)

    AppLogger.log_debug(self.class.name, "Message_type val: #{message_type}")

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

  def get_variant_reports(patient_id)

    variant_reports_dbm = NciMatchPatientModels::VariantReport.query_by_patient_id(patient_id, false).collect {|r| r}

    AppLogger.log_debug(self.class.name, "Patient [#{patient_id}] has #{variant_reports_dbm.length} variant reports")
    variant_reports_dbm
  end

  def get_variants_for_reports(variant_reports_dbm)
    variants_dbm = []
    variant_reports_dbm.each do |variant_report_dbm|
      variants = NciMatchPatientModels::Variant.find_by({"patient_id" => variant_report_dbm.patient_id,
                                                         "molecular_id" => variant_report_dbm.molecular_id,
                                                         "analysis_id" => variant_report_dbm.analysis_id}).collect {|r| r}
      variants_dbm.push(*variants)
    end

    AppLogger.log_debug(self.class.name,
                        "Patient has a total of #{variants_dbm.length} variants from #{variant_reports_dbm.length} variant reports")
    variants_dbm
  end

end

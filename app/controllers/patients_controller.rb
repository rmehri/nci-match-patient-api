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
  def dashboard_timeline
    render_event_data
  end

  # GET /patients/1/pendingItems
  def pending_items
    render_pendging_items params[:patientid]
  end

  # GET /patients/1/timeline
  def timeline
    render_event_patient_data params[:patientid]
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

      result = ConfirmResult.from_json input_data

      p result.to_h

      # response_json = PatientProcessor.run_service("/confirm_variant", input_data)

      # AppLogger.log(self.class.name, "\nResponse from Patient Processor: #{response_json}")
      # standard_success_message(JSON.parse(response_json)['message'])

    rescue => error
      standard_error_message(error.message)
    end
  end

  # PUT /patients/:patientid/variantReportStatus
  def variant_report_status
    begin
      input_data = get_post_data

      p 'input_data BEFORE'
      p input_data
      input_data.delete(:id)

      p 'input_data BEGIN'
      p input_data
      p 'input_data - END'

      # result = ConfirmResult.from_json input_data
      # p result.to_h

      success = validate(input_data)
      result = PatientProcessor.run_service('/confirmVariantReport', input_data)
      standard_success_message(result)
    rescue => error
      standard_error_message(error.message)
    end
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

  def render_event_data
    begin

      events_dbm = NciMatchPatientModels::Event.query_top 10

      AppLogger.log_debug(self.class.name, "Got #{events_dbm.count} events for dashboard") if !events_dbm.nil?
      events = events_dbm.map { |e_dbm| e_dbm.to_h }
      render json: events

    rescue => error
      standard_error_message(error.message)
    end
  end

  def render_pendging_items(patientid)
    begin
      pending_items = []      

      variant_report_dbms = NciMatchPatientModels::VariantReport.find_by({"status" => "PENDING", "patient_id" => params[:patientid]}).collect {|r| r}
      AppLogger.log_debug(self.class.name, "Got #{variant_report_dbms.length} variant reports for patient [#{params[:patientid]}]")

      variant_report_dbms.collect { |x| x }.each do |variant_report_dbm|
        pending_items.push ({
            "action_type" => variant_report_dbm.variant_report_type == 'TISSUE' ? 'pending_tissue_variant_report' : 'pending_blood_variant_report',
            "title" => variant_report_dbm.variant_report_type == 'TISSUE' ? 'Pending Tissue Variant Report' : 'Pending Blood Variant Report',
            "molecular_id" => variant_report_dbm.molecular_id,
            "analysis_id" => variant_report_dbm.analysis_id,
            "created_date" => variant_report_dbm.status_date.to_s
        })
      end

      assignment_report_dbms = NciMatchPatientModels::Assignment.find_by({"status" => "PENDING", "patient_id" => params[:patientid]}).collect {|r| r}
      AppLogger.log_debug(self.class.name, "Got #{assignment_report_dbms.length} assignment reports for patient [#{params[:patientid]}]")

      assignment_report_dbms.collect { |x| x }.each do |assignment_report_dbm|
        pending_items.push ({
            "action_type" => 'pending_assignment_report',
            "title" => 'Pending Assignment Report',
            "molecular_id" => assignment_report_dbm.molecular_id,
            "analysis_id" => assignment_report_dbm.analysis_id,
            "created_date" => assignment_report_dbm.status_date.to_s
        })
      end

      render json: pending_items
    rescue => error
      standard_error_message(error.message)
    end
  end

  def render_event_patient_data(patientid)
    begin
      events_dbm = NciMatchPatientModels::Event.query_events_by_entity_id(patientid, false).collect {|r| r}
      AppLogger.log_debug(self.class.name, "Got #{events_dbm.count} events for patient #{patientid}") if !events_dbm.nil?

      events = events_dbm.map { |e_dbm| e_dbm.to_h }
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

      shipments_dbm = NciMatchPatientModels::Shipment.find_by({"patient_id" => patient_id}).collect {|r| r}
      AppLogger.log_debug(self.class.name, "Found #{shipments_dbm.length} total shipments for patient [#{patient_id}]")

      variant_reports_dbm = get_variant_reports(patient_id)
      variants_dbm = get_variants_for_reports(variant_reports_dbm)

      uim = Convert::PatientDbModel.to_ui_model patient_dbm, variant_reports_dbm, variants_dbm, specimens_dbm, shipments_dbm
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

  def validate(message)
    type = MessageValidator.get_message_type(message)
    raise "Incoming message has UNKNOWN message type" if (type == 'UNKNOWN')

    error = MessageValidator.validate_json_message(type, message)
    raise "Incoming message failed message schema validation: #{error}" if !error.nil?

    status = validate_patient_state_no_queue(message, type)
    raise "Incoming message failed patient state validation" if (status == false)
    true
  end

  def validate_patient_state_no_queue(message, message_type)

    AppLogger.log(self.class.name, "Validating messesage of type [#{message_type}]")

    message_type = {message_type => message}
    p message_type
    result = StateMachine.validate(message_type)

    if result != 'true'
      result_hash = JSON.parse(result)
      raise "Incoming message failed patient state validation: #{result_hash['error']}"
    end

    true
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

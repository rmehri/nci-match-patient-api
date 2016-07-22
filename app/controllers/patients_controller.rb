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

      patient_dbm = NciMatchPatientModels::Patient.query_patient_by_id(patientid[0])
      raise "Unable to find patient #{patientid[0]}" if patient_dbm.nil?
      AppLogger.log_debug(self.class.name, "Got patient: #{patient_dbm.to_json}")

      specimens_dbm = NciMatchPatientModels::Specimen.query_specimens_by_patient_id(patientid[0], false).collect {|r| r}
      AppLogger.log_debug(self.class.name, "Got Specimen: #{specimens_dbm.to_json}")
      surgical_event_ids = specimens_dbm.map {|s| s.surgical_event_id}

      events_dbm = NciMatchPatientModels::Event.query_events_by_id(patientid[0], false).collect {|r| r}
      AppLogger.log_debug(self.class.name, "Got #{events_dbm.count} events for patient #{patientid[0]}") if !events_dbm.nil?

      p "============================= s_id: #{surgical_event_ids.to_json}"
      variant_reports_ui = get_variant_reports_ui(surgical_event_ids)

      p "============= Find #{variant_reports_ui.length} variant reports"

      uim = Convert::PatientDbModel.to_ui_model patient_dbm, events_dbm, variant_reports_ui, nil, specimens_dbm
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

  def get_variant_reports_ui(surgical_event_ids)
    variant_reports = []
    p "================== number of s id: #{surgical_event_ids.length}"
    return variant_reports if surgical_event_ids.length == 0

    surgical_event_ids.each do |surgical_event_id|
      total_mois = 0
      total_amois = 0
      total_confirmed_mois = 0
      total_confirmed_amoi = 0


      variant_reports_dbm = NciMatchPatientModels::VariantReport.query_by_surgical_event_id(surgical_event_id, false).collect {|r| r}
      p "============ got vrs: #{variant_reports_dbm.length}"
      next if variant_reports_dbm.length == 0

      variant_reports_dbm.each do |variant_report_dbm|
        variant_report_ui = Convert::PatientDbModel.to_ui_variant_report(variant_report_dbm)

        variants_dbm = NciMatchPatientModels::Variant.find_by({"surgical_event_id" => surgical_event_id,
                                                               "molecular_id" => variant_report_dbm.molecular_id,
                                                               "analysis_id" => variant_report_dbm.analysis_id}).collect {|r| r}
        next if variants_dbm.length == 0

        p "========== Found: #{variants_dbm.length} variants"

        variants = Convert::PatientDbModel.to_ui_variants(variants_dbm)
        variant_report_ui['variants'] = variants

        variants_dbm.each do |variant|
          total_mois += 1
          total_amois += 1 if variant.is_amois
          total_confirmed_mois += 1 if (variant.status == "CONFIRMED")
          total_confirmed_amois +=1 if (variant.status == "CONFIRMED" && variant.is_amois)
        end

        variant_report_ui['total_mois']  = total_mois
        variant_report_ui['total_amois']  = total_amois
        variant_report_ui['total_confirmed_mois']  = total_confirmed_mois
        variant_report_ui['total_confirmed_amois']  = total_confirmed_amoi




        variant_reports.push(variant_report_ui)

      end

      # variant_reports.push(*variant_reports_dbm)
    end
    p "============================ Done getthing VR"
    variant_reports
  end
end

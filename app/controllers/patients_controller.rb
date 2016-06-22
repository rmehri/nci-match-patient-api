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
    process_message
  end

  # POST /specimenReceipt
  def specimen_receipt
    process_message
  end

  # POST /assayOrder
  def assay_order
    process_message
  end

  # POST /variantResult
  def assay_result
    process_message
  end

  # POST /variantResult
  def variant_result
    process_message
  end

  # POST /pathologyStatus
  def pathology_status
    process_message
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

  def render_event_patient_data(patientid)
    begin
      json_data = NciMatchPatientModels::PatientEvent.scan(
          :scan_filter => {
              "patient_id" => {
                  :comparison_operator => "EQ",
                  :attribute_value_list => patientid
              }
          }
      );
      render json: json_data
    rescue => error
      standard_error_message(error)
    end
  end

  def render_patient_data(patientid)
    begin
      json_data = NciMatchPatientModels::Patient.scan(
          :scan_filter => {
              "patient_id" => {
                  :comparison_operator => "EQ",
                  :attribute_value_list => patientid
              }
          }
      ).collect{ |r| r};

      if json_data.length > 0
        patient_dbm = json_data[0]
        # events_dbm = events_db_model_list
        # variant_reports_dbm = variant_report_db_model_list
        # variants_dbm = variant_db_model_list
        # specimens_dbm = specimen_db_model_list

        uim = Convert::PatientDbModel.to_ui_model patient_dbm, nil, nil, nil, nil
        # uim = Convert::PatientDbModel.to_ui_model patient_dbm, events_dbm, variant_reports_dbm, variants_dbm, specimens_dbm

        # p uim
        uim
        render json: uim
      else
        standard_error_message "Unable to find Patient " + patientid.to_s
      end

    rescue => error
      standard_error_message(error)
    end
  end

  # def scan_record(record, patientid)
  #     record.scan(
  #         :scan_filter => {
  #             "patient_id" => {
  #                 :comparison_operator => "EQ",
  #                 :attribute_value_list => patientid
  #             }
  #         }
  #     )
  # end

  # def render_patient_event_data(patientid)
  #   begin
  #     json_data = scan_record NciMatchPatientModels::PatientEvent, patientid
  #     render json: json_data
  #   rescue => error
  #     standard_error_message(error)
  #   end
  # end

  # def render_patient_data(patientid)
  #   json_data = scan_record NciMatchPatientModels::Patient, patientid
  #
  #   if json_data.length > 0
  #     patient_dbm = json_data[0]
  #     # events_dbm = events_db_model_list
  #     # variant_reports_dbm = variant_report_db_model_list
  #     # variants_dbm = variant_db_model_list
  #     # specimens_dbm = specimen_db_model_list
  #
  #     uim = Convert::PatientDbModel.to_ui_model patient_dbm, nil, nil, nil, nil
  #     # uim = Convert::PatientDbModel.to_ui_model patient_dbm, events_dbm, variant_reports_dbm, variants_dbm, specimens_dbm
  #
  #     # p uim
  #     uim
  #   else
  #     raise "Unable to find Patient " + patientid.to_s
  #   end
  # end

  def valid_test_message
    {:valid => true }
  end

  def invalid_test_message
    {:valid => false }
  end

  def process_message
    if validate_and_queue
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
    json_data.deep_transform_keys!(&:underscore).symbolize_keys!
  end

  def validate_and_queue
    message = get_post_data

    if StateMachine.validate(message)
      Aws::Sqs::Publisher.publish(message, Config::Queue.name('processor'))
      return true
    else
      return false
    end
  end
end

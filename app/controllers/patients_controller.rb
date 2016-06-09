class PatientsController < ApplicationController
  # before_action :authenticate

  # GET /patients
  def patient_list
    begin
      render json: Patient.scan({}).collect { |data| data.to_h }
    rescue => error
      standard_error_message(error)
    end
  end

  # GET /patients/1/timeline
  def timeline
    render_patient_data PatientEvent, [params[:patientid]]
  end

  # GET /patients/1
  def patient
    render_patient_data Patient, [params[:patientid]]
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

  # POST /patients/1/variantreport/{confirmed:"0|1", comments:"Some comments"}
  # def variantreport
  #   begin
  #     json_string = request.raw_post
  #
  #     begin
  #       confirmResultModel = ConfirmResult.from_json(json_string)
  #     rescue
  #       render json: {:status => "FAILURE", :message => "Invalid data received. Please check data format."}, :status => 400
  #     end
  #
  #     if confirmResultModel != nil
  #       Pe::Processor.confirmVariantReport(confirmResultModel)
  #       render json: {:status => "SUCCESS"}, :status => 200
  #     end
  #
  #   rescue => error
  #     p error
  #     standard_error_message(error)
  #   end
  # end


  # def new_patient
  #   begin
  #     @treatment_arm = JSON.parse(request.raw_post)
  #     @treatment_arm.deep_transform_keys!(&:underscore).symbolize_keys!
  #     treatment_arm_model = TreatmentArm.new.from_json(TreatmentArm.new.convert_models(@treatment_arm).to_json)
  #     if treatment_arm_model.valid?
  #       Aws::Publisher.publish(@treatment_arm)
  #       render json: {:status => "SUCCESS"}, :status => 200
  #     else
  #       render json: {:status => "FAILURE", :message => "Validation failed.  Please check all required fields are present"}, :status => 400
  #     end
  #   rescue => error
  #     standard_error_message(error)
  #   end
  # end

  private

  def render_patient_data(record, patientid)
    begin
      json_data = record.scan(
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

    if NciMatchPatientApi::StateMachine.validate(message)
      Aws::Sqs::Publisher.publish(message, Config::Queue.name('processor'))
      return true
    else
      return false
    end
  end
end

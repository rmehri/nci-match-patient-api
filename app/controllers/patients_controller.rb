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
    render status: 200, json: '{"test":"test"}'
  end

  # POST /specimenReceipt
  def specimen_receipt
    render status: 200, json: '{"test":"test"}'
  end

  # POST /assayOrder
  def assay_order
    render status: 200, json: '{"test":"test"}'
  end

  # POST /variantResult
  def assay_result
    render status: 200, json: '{"test":"test"}'
  end

  # POST /variantResult
  def variant_result
    render status: 200, json: '{"test":"test"}'
  end

  # POST /pathologyStatus
  def pathology_status
    render status: 200, json: '{"test":"test"}'
  end

  # POST /patients/:patientid/sampleFile
  def sample_file
    render status: 200, json: '{"test":"test"}'
  end

  # POST /patients/:patientid/variantStatus
  def variant_status
    render status: 200, json: '{"test":"test"}'
  end

  # POST /patients/:patientid/variantReportStatus
  def variant_report_status
    render status: 200, json: '{"test":"test"}'
  end

  # POST /patients/:patientid/assignmentConfirmation
  def assignment_confirmation
    render status: 200, json: '{"test":"test"}'
  end

  # POST /patientStatus
  def patient_status
    render status: 200, json: '{"test":"test"}'
  end

  # GET /patients/:patientid/documents
  def document_list
    Aws::Publisher.publish('{"test":"test"}', Config::Queue.name('processor'))
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
end

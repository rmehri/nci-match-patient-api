class PatientsController < ApplicationController
  # before_action :authenticate

  # GET /patients
  def index
    begin
      render json: Patient.scan({}).collect { |data| data.to_h }
    rescue => error
      standard_error_message(error)
    end
  end
  # def index
  #   file = File.read('./data/patient_list.json')
  #   data_hash = JSON.parse(file)
  #   render json: data_hash
  # end


  # GET /patients/1/timeline
  def timeline
    render_patient_data PatientEvent, [params[:id]]
  end
  # def timeline
  #   file = File.read('./data/patient_timeline.json')
  #   data_hash = JSON.parse(file)
  #   render json: data_hash
  # end


  # GET /patients/1
  # GET /patients/1.json
  def show
    render_patient_data Patient, [params[:id]]
  end
  # def show
  #   file = File.read('./data/patient.json')
  #   data_hash = JSON.parse(file)
  #   render json: data_hash
  # end


  # POST /patients/1/variantreport/{confirmed:"0|1", comments:"Some comments"}
  def variantreport
    begin
      json_string = request.raw_post

      begin
        confirmResultModel = ConfirmResult.from_json(json_string)
      rescue
        render json: {:status => "FAILURE", :message => "Invalid data received. Please check data format."}, :status => 400
      end

      if confirmResultModel != nil
        Pe::Processor.confirmVariantReport(confirmResultModel)
        render json: {:status => "SUCCESS"}, :status => 200
      end

    rescue => error
      p error
      standard_error_message(error)
    end
  end

  private
  def render_patient_data(record, id)
    begin
      json_data = record.scan(
          :scan_filter => {
              "patient_id" => {
                  :comparison_operator => "EQ",
                  :attribute_value_list => id
              }
          }
      );
      render json: json_data
    rescue => error
      standard_error_message(error)
    end
  end
end

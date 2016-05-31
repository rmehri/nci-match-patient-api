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
    begin
      if !params[:id].nil?
        json_result = PatientEvent.scan(:scan_filter => {
            "patient_id" => {
                :comparison_operator => "EQ",
                :attribute_value_list => [params[:id]]
            }
        }).collect { |data| data.to_h }
      end
      render json: json_result
    rescue => error
      standard_error_message(error)
    end
  end
  # def timeline
  #   file = File.read('./data/patient_timeline.json')
  #   data_hash = JSON.parse(file)
  #   render json: data_hash
  # end

  # GET /patients/1
  # GET /patients/1.json
  def show
    begin
      if !params[:id].nil?
        json_result = Patient.scan(:scan_filter => {
            "patient_id" => {
                :comparison_operator => "EQ",
                :attribute_value_list => [params[:id]]
            }
        }).collect { |data| data.to_h }
      end
      render json: json_result
    rescue => error
      standard_error_message(error)
    end
  end
  # def show
  #   file = File.read('./data/patient.json')
  #   data_hash = JSON.parse(file)
  #   render json: data_hash
  # end

  # POST /patients/1/variantreport/{confirm:"0|1", comments:"Some comments"}
  def variantreport
    begin
      post_data = JSON.parse(request.raw_post)
      post_data.deep_transform_keys!(&:underscore).symbolize_keys!
      confirmResultModel = ConfirmResult.new.from_json(ConfirmResult.new.convert_models(post_data).to_json)

      if treatment_arm_model.valid?
        Aws::Publisher.publish(@treatment_arm)
        render json: {:status => "SUCCESS"}, :status => 200
      else
        render json: {:status => "FAILURE", :message => "Validation failed.  Please check all required fields are present"}, :status => 400
      end

    rescue => error
      standard_error_message(error)
    end
  end

end

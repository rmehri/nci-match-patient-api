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
    file = File.read('./data/patient_timeline.json')
    data_hash = JSON.parse(file)
    render json: data_hash
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
    file = File.read('./data/patient.json')
    data_hash = JSON.parse(file)
    render json: data_hash
  end

end

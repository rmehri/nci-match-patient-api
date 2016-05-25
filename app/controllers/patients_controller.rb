class PatientsController < ApplicationController
  # GET /patients/version
  def version
    render json: 'Patient API version 0.1'
  end

  # GET /patients
  def index
    file = File.read('./data/patient_list.json')
    data_hash = JSON.parse(file)
    render json: data_hash
  end

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

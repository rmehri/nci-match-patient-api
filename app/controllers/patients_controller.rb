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

  # GET /patients/test_file
  def test_file
    render json: 'Test File'
    # render json: JSON.parse(File.new('./data/fake.json').to_s);
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
    file = File.read('./data/patient.json')
    data_hash = JSON.parse(file)
    render json: data_hash
  end
end

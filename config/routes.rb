Rails.application.routes.draw do

  routing_path = "api/v1"

  controller :version do
    get "#{routing_path}/patients/version" => :version
  end

  controller :patients do
    get "#{routing_path}/patients" => :patient_list
    get "#{routing_path}/patients/timeline" => :dashboard_timeline

    get "#{routing_path}/patients/variant_reports" => :variant_reports

    get "#{routing_path}/patients/specimens" => :specimens

    get "#{routing_path}/patients/:patient_id" => :patient
    get "#{routing_path}/patients/:patient_id/timeline" => :timeline

    get "#{routing_path}/patients/:patient_id/specimens" => :patient_specimens

    get "#{routing_path}/patients/variant_reports" => :variant_reports
    get "#{routing_path}/patients/:patient_id/variant_reports" => :patient_variant_reports
    get "#{routing_path}/patients/:patient_id/variant_reports/:molecular_id/:analysis_id" => :patient_variant_report

    get "#{routing_path}/patients/assignment_reports" => :assignment_reports
    get "#{routing_path}/patients/:patient_id/assignment_reports" => :patient_assignment_reports
    get "#{routing_path}/patients/:patient_id/assignment_reports/:date_assigned" => :patient_assignment_report

    get "#{routing_path}/patients/:patient_id/samples" => :sample_files
    get "#{routing_path}/patients/:patient_id/samples/:molecular_id/:analysis_id/:file_name" => :sample_file

    put "#{routing_path}/patients/:patient_id/variant_reports/:molecular_id/:analysis_id" => :variant_report_status
    put "#{routing_path}/patients/:patient_id/assignment_reports/:date_assigned" => :assignment_confirmation
    put "#{routing_path}/patients/variant/:variant_uuid/" => :variant_status

    get "#{routing_path}/patients/:patient_id/specimens/:molecular_id/specimen_shipped" => :specimen_shipped

    get "#{routing_path}/patients/:patient_id/documents" => :document_list
    get "#{routing_path}/patients/:patient_id/documents/:document_id" => :document
    post "#{routing_path}/patients/:patient_id/documents" => :new_document

    get "#{routing_path}/patients/statistics" => :statistics

  end

  controller :services do
    post "#{routing_path}/patients/:patient_id" => :trigger
  end

  controller :dashboard do
    get "#{routing_path}/patients/sequencedAndConfirmedPatients" => :sequenced_and_confirmed_patients
  end

  controller :specimen_tracking do
    get "#{routing_path}/patients/shipments" => :shipments
  end
  
end

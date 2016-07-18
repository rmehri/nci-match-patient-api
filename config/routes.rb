Rails.application.routes.draw do
  controller :version do
    get 'version' => :version
  end

  controller :patients do
    get 'patients' => :patient_list
    get "patients/:patientid" => :patient
    get "patients/:patientid/timeline" => :timeline
    get "patients/:patientid/sampleHistory/:sampleid" => :sample
    get "patients/:patientid/qcVariantReport/:sampleid/:type" => :qc_variant_report

    post "patients/:patientid/sampleFile" => :sample_file
    put "patients/:patientid/variantStatus" => :variant_status
    put "patients/:patientid/variantReportStatus" => :variant_report_status
    post "patients/:patientid/assignmentConfirmation" => :assignment_confirmation
    post "patientStatus" => :patient_status
    get "patients/:patientid/variantReportQc" => :qc_variant_report

    get "patients/:patientid/documents" => :document_list
    get "patients/:patientid/documents/:documentid" => :document
    post "patients/:patientid/documents" => :new_document
  end

  controller :services do
    post "api/patient/trigger" => :trigger
  end
end

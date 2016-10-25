Rails.application.routes.draw do

  scope '/api/v1', module: 'v1' do

    resources :patients, only: [:show, :index, :create] do
      collection do
        get 'version', controller: 'versions', action: :version
        get 'statistics', controller: 'statistics', action: :patient_statistics
        get 'pending_view', controller: 'pending_view', action: :pending_view
        get 'amois', controller: 'statistics', action: :sequenced_and_confirmed_patients
        resources :events , :variant_reports, :variants, :assignments, :shipments, only: [:show, :index]
      end
      resources :action_items, only: [:index]
      resources :treatment_arm_history, only: [:index]

      resources :specimens, only: [:show, :index]
      resources :specimen_events, only: [:index]

      resources :qc_variant_reports, only: [:show]
    end

    # controller :patients do
    #   get "patients" => :patient_list
    #   get "patients/timeline" => :dashboard_timeline
    #
    #   get "patients/variant_reports" => :variant_reports
    #
    #   get "patients/specimens" => :specimens
    #   get "patients/shipments" => :shipments
    #   get "patients/sequencedAndConfirmedPatients" => :sequenced_and_confirmed_patients
    #   get "patients/statistics" => :statistics
    #
    #   get "patients/assignment_reports" => :assignment_reports
    #
    #   get "patients/:patient_id" => :patient
    #   get "patients/:patient_id/timeline" => :timeline
    #
    #   get "patients/:patient_id/specimens" => :patient_specimens
    #
    #
    #   get "patients/:patient_id/variant_reports" => :variant_reports
    #   get "patients/:patient_id/variant_reports/:molecular_id/:analysis_id" => :patient_variant_report
    #
    #   get "patients/:patient_id/assignment_reports" => :patient_assignment_reports
    #   get "patients/:patient_id/assignment_reports/:date_assigned" => :patient_assignment_report
    #
    #   get "patients/:patient_id/samples" => :sample_files
    #   get "patients/:patient_id/samples/:molecular_id/:analysis_id/:file_name" => :sample_file
    #
    #   get "patients/:patient_id/specimens/:molecular_id/specimen_shipped" => :specimen_shipped
    #
    #   get "patients/:patient_id/documents" => :document_list
    #   get "patients/:patient_id/documents/:document_id" => :document
    #   post "patients/:patient_id/documents" => :new_document
    #
    # end

    controller :services do
      post "patients/:patient_id" => :trigger

      put "patients/:patient_id/variant_reports/:analysis_id/:status" => :variant_report_status
      put "patients/:patient_id/assignment_reports/:analysis_id/:status" => :assignment_confirmation
      put "patients/variant/:variant_uuid/:status" => :variant_status

    end

    # controller :dashboard do
    #   get "patients/sequencedAndConfirmedPatients" => :sequenced_and_confirmed_patients
    # end

    # controller :specimen_tracking do
    #   get "patients/shipments" => :shipments
    # end
  end
end

Rails.application.routes.draw do
  scope '/api/v1', module: 'v1' do
    resources :patients, only: [:show, :index, :create] do
      collection do
        get 'version', controller: 'versions', action: :version
        get 'statistics', controller: 'statistics', action: :patient_statistics
        get 'pending_items', controller: 'pending_view', action: :pending_view
        get 'amois', controller: 'statistics', action: :sequenced_and_confirmed_patients
        get ':patient_id/variant_report/:analysis_id', to: 'variant_report_downloads#download_excel'
        resources :variant_reports, :variants, :assignments, :shipments, only: [:show, :index]
        resources :patient_limbos, :specimens, :assays, only: [:index]
        resources :events, only: [:show, :index, :create]

        resources :shipment_status, only: [:show]
      end

      resources :action_items, only: [:index]
      resources :treatment_arm_history, only: [:index]

      resources :specimens, only: [:show, :index]
      resources :specimen_events, only: [:index]
      resources :analysis_report, only: [:show]
      resources :analysis_report_amois, only: [:show]
      resources :qc_variant_reports, only: [:show]
      resources :variant_file_download, only: [:show]

    end

    controller :services do
      post "patients/:patient_id" => :trigger
      post "patients/variant_report/:molecular_id" => :variant_report_uploaded

      put "patients/:patient_id/variant_reports/:analysis_id/:status" => :variant_report_status
      put "patients/:patient_id/assignment_reports/:analysis_id/:status" => :assignment_confirmation
      put "patients/variant/:variant_uuid/:status" => :variant_status

    end
    match "*path", to: 'errors#bad_request', via: :all
  end
end
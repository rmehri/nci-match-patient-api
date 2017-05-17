Rails.application.routes.draw do
  apipie
  scope '/api/v1', module: 'v1' do
    resources :patients, only: [:show, :index, :create] do
      collection do
        get 'version', controller: 'versions', action: :version
        get 'statistics', controller: 'statistics', action: :patient_statistics
        get 'pending_items', controller: 'pending_view', action: :pending_view
        get 'amois', controller: 'statistics', action: :sequenced_and_confirmed_patients
        get ':patient_id/variant_report/:analysis_id', to: 'report_downloads#variant_report_download'
        get ':patient_id/assignment_report/:uuid', to: 'report_downloads#assignment_report_download'
        resources :variant_reports, :variants, :assignments, :shipments, only: [:show, :index]
        resources :patient_limbos, :specimens, :assays, only: [:index]
        resources :events, only: [:show, :index, :create]
        resources :shipment_status, only: [:show]
        patch 'users', to: 'users#update'
        get 'healthz', to: 'patients#health_check'
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

      put "patients/:patient_id/variant_reports/:analysis_id/:status" => :variant_report_status, :defaults => {:status => ['confirm', 'reject']}
      put "patients/:patient_id/assignment_reports/:analysis_id/:status" => :assignment_confirmation, :defaults => {:status => ['confirm', 'reject']}
      put "patients/variant/:variant_uuid/:status" => :variant_status, :defaults => {:status => ['checked','unchecked']}

    end
    controller :roll_back do
      put "patients/:patient_id/variant_report_rollback" => :rollback_variant_report
      put "patients/:patient_id/assignment_report_rollback" => :rollback_assignment_report
    end

    match "*path", to: 'errors#bad_request', via: :all
  end

  scope '/api/v2', module: 'v2' do
    resources :patients, only: [:show, :index, :create] do
      collection do
        resource :versions, only: [:show]
      end
    end
  end
end
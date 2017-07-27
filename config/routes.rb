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
        resources :variants, :shipments, only: [:show, :index]
        resources :variant_reports, :assignments, only: [:show, :index]
        resources :patient_limbos, :specimens, :assays, only: [:index]
        resources :events, only: [:show, :index, :create]
        resources :shipment_status, only: [:show]
        patch 'users', to: 'users#update'
        get 'healthcheck', to: 'health_checks#health_check'
      end



      resources :action_items, only: [:index]
      resources :s3, only: [:create, :show, :index]
      resources :treatment_arm_history, only: [:index]

      resources :specimens, only: [:show, :index]
      resources :specimen_events, only: [:index]
      resources :analysis_report, only: [:show]
      resources :analysis_report_amois, only: [:show]
      resources :qc_variant_reports, only: [:show]
      resources :variant_file_download, only: [:show]

    end

    # input processing for patient processor API
    controller :messages do
      # specimen received type
      post "patients/:patient_id/message/specimen_received" => :specimen_received

      # specimen shipped type
      post "patients/:patient_id/message/specimen_shipped" => :specimen_shipped

      # assay type
      post "patients/:patient_id/message/assay" => :assay

      # variant report status type
      post "patients/:patient_id/message/variant_report" => :variant_report

      # cog type
      post "patients/:patient_id/message/cog" => :cog
    end

    # input processing for local changes
    controller :services do

      # this route is rewritten in ServicesRoutesMiddleware - it is re-routed to messages controller above
      # TODO: obsolete, should be removed after refactoring is done
      post  "patients/:patient_id" => :trigger, :as => 'trigger'

      # upload variant report
      post  "patients/variant_report/:molecular_id" => :variant_report_uploaded

      # set variant report status
      put   "patients/:patient_id/variant_reports/:analysis_id/:status" => :variant_report_status, :defaults => {:status => ['confirm', 'reject']}

      # set assignment status
      put   "patients/:patient_id/assignment_reports/:analysis_id/:status" => :assignment_confirmation, :defaults => {:status => ['confirm', 'reject']}

      # set variant status
      put   "patients/variant/:variant_uuid/:status" => :variant_status, :defaults => {:status => ['checked','unchecked']}
    end

    # controller :services do
    #   post "patients/:patient_id" => :trigger
    #   post "patients/variant_report/:molecular_id" => :variant_report_uploaded
    #
    #   put "patients/:patient_id/variant_reports/:analysis_id/:status" => :variant_report_status, :defaults => {:status => ['confirm', 'reject']}
    #   put "patients/:patient_id/assignment_reports/:analysis_id/:status" => :assignment_confirmation, :defaults => {:status => ['confirm', 'reject']}
    #   put "patients/variant/:variant_uuid/:status" => :variant_status, :defaults => {:status => ['checked','unchecked']}
    #
    # end

    controller :rollback do
      put "patients/:patient_id/variant_report_rollback" => :variant_report
      put "patients/:patient_id/assignment_report_rollback" => :assignment_report
      put "patients/:patient_id/rollback" => :rollback
    end

    match "*path", to: 'errors#bad_request', via: :all
  end

  scope '/api/v2', module: 'v2' do
    resources :patients, only: [:show, :index, :create] do
      collection do
        resource :versions, only: [:show]
        resource :health_checks, only: [:show]
      end
    end
  end
end

Rails.application.routes.draw do

  # api docs generator
  apipie

  scope '/api/v1', module: 'v1' do # main scope

    # /api/v1/patients scope
    resources :patients, only: [:show, :index, :create] do
      collection do

        # TODO: remove this - commented code for password change
        patch 'users', controller: :users, action: :update

        resources :events,          only: [:show, :index, :create]
        resources :variants,        only: [:show, :index]
        resources :shipments,       only: [:show, :index]
        resources :variant_reports, only: [:show, :index]
        resources :assignments,     only: [:show, :index]
        resources :patient_limbos,  only: [:index]
        resources :specimens,       only: [:index]
        resources :assays,          only: [:index]
        resources :shipment_status, only: [:show]

        get 'statistics',     controller: :statistics,    action: :patient_statistics
        get 'amois',          controller: :statistics,    action: :sequenced_and_confirmed_patients
        get 'pending_items',  controller: :pending_view,  action: :pending_view

        get 'version',        controller: :versions,      action: :version      # app/rails/ruby version and commit/build info
        get 'healthcheck',    controller: :health_checks, action: :health_check # aws infrastructure info (dynamo, s3, sqs)

        get ':patient_id/variant_report/:analysis_id',    controller: :report_downloads, action: :variant_report_download
        get ':patient_id/assignment_report/:uuid',        controller: :report_downloads, action: :assignment_report_download
      end

      resources :s3,                    only: [:show, :index, :create]
      resources :specimens,             only: [:show, :index]
      resources :action_items,          only: [:index]
      resources :treatment_arm_history, only: [:index]
      resources :specimen_events,       only: [:index]
      resources :analysis_report,       only: [:show]
      resources :analysis_report_amois, only: [:show]
      resources :qc_variant_reports,    only: [:show]
      resources :variant_file_download, only: [:show]
    end

    # input processing for patient processor queue
    # re-routed from middleware
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

      # TAs change notification
      post 'patients/treatment_arms' => :treatment_arms_changed

      # this route is rewritten in ServicesRoutesMiddleware - it is re-routed to messages controller above
      post  "patients/:patient_id" => :trigger, :as => 'trigger' # I DONT EXIST !!!

      # upload variant report
      post  "patients/variant_report/:molecular_id" => :variant_report_uploaded

      # set variant report status
      put   "patients/:patient_id/variant_reports/:analysis_id/:status" => :variant_report_status, :defaults => {:status => ['confirm', 'reject']}

      # set assignment status
      put   "patients/:patient_id/assignment_reports/:analysis_id/:status" => :assignment_confirmation, :defaults => {:status => ['confirm', 'reject']}

      # set variant status
      put   "patients/variant/:variant_uuid/:status" => :variant_status, :defaults => {:status => ['checked','unchecked']}
    end

    controller :rollback do
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

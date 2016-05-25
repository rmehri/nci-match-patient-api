Rails.application.routes.draw do
  get 'patients/version'

  get 'patients', to: 'patients#index'
  get "patients/:id" => "patients#show"
  get "patients/:id/timeline" => "patients#timeline"
end

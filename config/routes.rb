Rails.application.routes.draw do
  get 'patients/version'

  get 'patients/test_file' => 'patients#test_file'
  get 'patients', to: 'patients#index'
  get "patients/:id" => "patients#show"
end

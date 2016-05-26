Rails.application.routes.draw do
  controller :version do
    get 'version' => :version
  end

  controller :patients do
    get 'patients' => :index
    get "patients/:id" => :show
    get "patients/:id/timeline" => :timeline
  end
end

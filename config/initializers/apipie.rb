Apipie.configure do |config|
  config.app_name                = 'NciPedMatchPatientApi'
  config.copyright               = '© 2017 PedMATCH'
  config.api_base_url            = 'api/v1'
  config.doc_base_url            = '/api/v1/patients/apidocs'
  config.validate                = false
  config.use_cache               = Rails.env.production?
  config.api_controllers_matcher = File.join(Rails.root, 'app', 'controllers', 'v1', '*.rb')
  config.api_routes              = Rails.application.routes
  config.reload_controllers      = true
  config.debug                   = false
  config.languages               = ['en']
  config.default_locale          = 'en'
  config.app_info                = <<-DOC
    This ecosystem is responsible for receiving and processing patient messages that comes from third party systems and other ecosystems within the uMATCH system.
    This ecosystem is in charge of maintaining its own set of data models that would assist the customer in answering questions centered around patients.
  DOC
end

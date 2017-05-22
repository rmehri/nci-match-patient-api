Apipie.configure do |config|
  config.app_name                = 'NciPedMatchPatientApi'
  config.copyright               = '© 2017 PedMATCH'
  config.api_base_url            = 'api/v1'
  config.doc_base_url            = '/api/v1/patients/apidocs'
  config.validate                = false
  config.use_cache               = Rails.env.test? || Rails.env.uat?
  config.api_controllers_matcher = File.join(Rails.root, 'app', 'controllers', 'v1', '*.rb')
  config.reload_controllers      = true
  config.debug                   = false
  config.app_info                = <<-DOC
    Application Description
  DOC
end

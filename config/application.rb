require File.expand_path('../boot', __FILE__)
require File.expand_path('../version', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"
require 'wannabe_bool'
require 'httparty'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NciMatchPatientApi
  class Application < Rails::Application
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '*')]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{*/}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'controllers', '*')]
    config.autoload_paths += Dir[Rails.root.join('app', 'controllers', '{*}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'helpers', '{*/}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'validators', '{*/}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'services', '{*/}')]
    config.autoload_paths += Dir[Rails.root.join('lib')]

    config.logger = Logger.new(STDOUT)
    config.logger.formatter = Proc.new { |severity, datetime, progname, msg| "[#{datetime.strftime("%B %d %H:%M:%S")}] [#{$$}] [#{severity}] [#{Rails.application.class.parent_name}], #{msg}\n"}

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :put, :options]
      end
    end
    config.environment = Rails.application.config_for(:environment)

    config.exceptions_app = self.routes

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    #config.active_record.raise_in_transactional_callbacks = true
  end
end

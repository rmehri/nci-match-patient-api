require File.expand_path('../boot', __FILE__)

require "rails"
require File.expand_path('../version', __FILE__)

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

module NciPedMatchPatientApi
  class Application < Rails::Application
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '*')]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{*/}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'controllers', '*')]
    config.autoload_paths += Dir[Rails.root.join('app', 'controllers', '{*}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'helpers', '{*/}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'messages', '{*/}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'validators', '{*/}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'services', '{*/}')]
    config.autoload_paths += Dir[Rails.root.join('lib')]

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :put, :options]
      end
    end

    config.environment = Rails.application.config_for(:environment)
    config.assay = Rails.application.config_for(:assay)

    config.exceptions_app = self.routes

    config.active_job.queue_adapter = :shoryuken

    # for dynamo, dalli and others
    config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

    # customize rails default request logging
    config.lograge.enabled = true

    # add params and time to logger
    config.lograge.custom_options = lambda do |event|
      {
        # params: event.payload[:params].except(*%w(controller action format id payload)), # payload wraps the params using wrap_parameters
        time: event.time
      }
    end

    # add custom data to logger
    config.lograge.custom_payload do |controller|
      {
        host: controller.request.host,
        uuid: controller.request.uuid
      }
    end

    # data available to formatter:
    # {:method=>"POST", :path=>"/api/v1/patients/37/message/cog", :format=>"*/*", :controller=>"V1::MessagesController",
    # :action=>"cog", :status=>403, :duration=>283.62, :view=>0.3, :time=>2017-10-10 14:40:47 -0400,
    # :host=>"localhost", :uuid=>"ea8cabc3-d59f-48f9-be69-01bfc90de905"}
    config.lograge.formatter = Proc.new do |data|
      tags = "[#{data[:time]}] [#{Rails.application.class.parent}] [#{data[:uuid]}] [INFO] " # space for alignment
      "#{tags} Completed #{data[:status]} #{Rack::Utils::HTTP_STATUS_CODES[data[:status]]} in #{data[:duration]}ms (View: #{data[:view]}ms)\n\n"
    end

    # add service re-routing middleware to bottom
    require_relative '../lib/services_routes_middleware.rb'
    config.middleware.use NciPedMatchPatientApi::ServicesRoutesMiddleware
  end
end

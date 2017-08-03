source 'https://rubygems.org'

gem 'rails', '5.1.2'

# web server
gem 'puma'

# telemetry service
gem 'newrelic_rpm'

# slack
gem 'slack-logger', git: 'https://github.com/damir/slack-logger.git'

# JWT authentication
gem 'knock'

# authorization
gem 'cancan', git: 'https://github.com/damir/cancan.git'

# cors
gem 'rack-cors'

# DynamoDB
gem 'aws-sdk'
gem 'aws-sdk-rails'
gem 'aws-record'

# fast JSON parser and Object marshaller
gem 'oj'

# generate JSON objects with a Builder-style DSL
gem 'jbuilder'

# AWS SQS thread-based message processor.
gem 'shoryuken'

# JSON Schema Validator
gem 'json-schema'

# reading and writing zip files
gem 'rubyzip'

# Office Open XML Spreadsheet Generation
gem 'axlsx'
gem 'axlsx_rails'

# If string, numeric, symbol and nil values wanna be a boolean value, they can with the new #to_b method
gem 'wannabe_bool'

# A set of Rails responders to dry up your application
gem 'responders'

# in-house gem
gem 'nci_match_patient_models', git: 'https://github.com/CBIIT/nci-match-lib.git', tag: 'v1.1.23'
gem 'nci_match_roles', git: 'https://github.com/CBIIT/nci_match_roles.git', tag: 'v1.1.0'

# http client
gem 'httparty'

# API documentation tool
gem 'apipie-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # rspec
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'

  # fixtures
  gem 'factory_girl_rails'

  # generate fake data
  gem 'faker'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # code coverage
  gem 'simplecov'

  # coverage report for Codacy
  gem 'codacy-coverage', require: false

  # stubbing and setting expectations on HTTP requests
  gem 'webmock'

  # brings back assigns to your controller tests
  gem 'rails-controller-testing'
end

group :development do

end

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

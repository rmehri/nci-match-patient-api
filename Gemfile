source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.0.1'
gem 'sass-rails', '~> 5.0'

gem 'newrelic_rpm', '3.17.1.326'

# Use jquery as the JavaScript library
gem 'jquery-rails', '4.2.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.6.1'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '0.4.2', group: :doc

gem 'rack-cors', '0.4.0'

gem 'aws-sdk', '2.6.34'
gem 'aws-sdk-rails', '1.0.1'
gem 'aws-record', '>= 1.0.0.pre.8'
gem 'json-schema', '2.7.0'
gem 'cancan'
gem 'knock', '2.0'
gem 'rubyzip', '= 1.0.0'
gem 'axlsx', '= 2.0.1'
gem 'axlsx_rails'

gem 'wannabe_bool', '0.6.0'
gem 'responders', '2.3.0'

gem 'slack-logger'
gem 'nci_match_patient_models', git: 'git://github.com/CBIIT/nci-match-lib.git', tag: 'v1.1.15'
gem 'nci_match_roles', git: 'git://github.com/CBIIT/nci_match_roles.git', tag: 'v1.1.0'

gem 'httparty', '0.14.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails', '~> 3.0'
  gem 'rspec-activemodel-mocks'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'simplecov'
  # Ruby coverage report for Codacy
  gem 'codacy-coverage', require: false
  gem 'webmock'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

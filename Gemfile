source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
gem 'sass-rails', '~> 5.0'

gem 'newrelic_rpm'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'rack-cors'

gem 'aws-sdk', '~>2'
gem 'aws-sdk-rails'
gem 'aws-record', '>= 1.0.0.pre.8'
gem 'json-schema'

gem 'knock', '~> 1.4.2'
gem 'auth0'

gem 'wannabe_bool'
gem 'responders'

gem 'nci_match_patient_models', :git => 'git://github.com/CBIIT/nci-match-lib.git', :branch => 'master'

gem "httparty"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
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
  gem "simplecov"
  gem "codeclimate-test-reporter", "~> 1.0.0"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

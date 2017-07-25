# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

# NOTE: this does not work with rails 5.1.2, port and host are now set in puma.rb and Dockerfile 
# require 'rails/commands/server'
#
# module DefaultOptions
#   def default_options
#     super.merge!(Port: 10240)
#   end
# end
#
# Rails::Server.send(:prepend, DefaultOptions)

# Load the Rails application.
require File.expand_path('../application', __FILE__)

require 'sqs'
require 'convert_variant_report'
require 'convert_assignment'

# Initialize the Rails application.
Rails.application.initialize!

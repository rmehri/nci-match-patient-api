# Load the Rails application.
require File.expand_path('../application', __FILE__)

require 'sqs'
require 'aws/s3/s3_reader'
require 'convert_variant_report'
require 'convert_assignment'

# Initialize the Rails application.
Rails.application.initialize!


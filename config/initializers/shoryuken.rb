# Shoryuken.configure_server do | config |
#   logger = Shoryuken::Logging.initialize_logger(STDOUT)
#   logger.formatter = Proc.new { |severity, datetime, progname, msg| "[#{SecureRandom.uuid}] [#{datetime.strftime("%B %d %H:%M:%S")}] [#{$$}] [#{severity}] [#{Rails.application.class.parent_name}], #{msg}\n"}
#   logger.level = Logger::INFO
#   Rails.logger = logger
# end

# region = Rails.configuration.environment.fetch('aws_region')
# end_point = "https://sqs.#{region}.amazonaws.com"
#
# Shoryuken.sqs_client = Aws::SQS::Client.new(endpoint: end_point, region: region)

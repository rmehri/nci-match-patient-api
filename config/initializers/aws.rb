# configure aws
Aws.config.update(endpoint: Rails.configuration.environment.fetch('aws_dynamo_endpoint'),
                  region: Rails.configuration.environment.fetch('aws_region')) unless Rails.env.test_local?

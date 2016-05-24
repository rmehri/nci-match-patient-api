Aws.config.update({
                      endpoint: 'https://dynamodb.us-east-1.amazonaws.com',
                      access_key_id: Rails.application.secrets.aws_access_key_id,
                      secret_access_key: Rails.application.secrets.aws_secret_access_key,
                      region: 'us-east-1'
                  })
class AbstractMessage
  include ActiveModel::Serializers::JSON
  include ActiveModel::Validations
  extend ActiveModel::Callbacks

  define_model_callbacks :from_json
  after_from_json :include_correct_module

  def from_json(json, include_root=include_root_in_json)
    _run_from_json_callbacks do
      super
    end
  end

  def include_correct_module
    # override this in subclass
  end

  def attributes=(hash)
    hash.each do |key, value|
      begin
        send("#{key}=", value)
      rescue => error
        next
      end
    end
  end

  def attributes
    instance_values
  end

  class << self; attr_reader :message_format end

  class ValidationError < StandardError; end

  attr_accessor :message

  # build the message object from hash
  def self.from_hash(hash)
    instance = new.from_json(hash.to_json) # TODO: we should build object only from hash, not json - rails cast json to hash automatically
    raise ValidationError, "#{instance.class} failed message schema validation: #{instance.errors.messages}" unless instance.valid?
    instance.message = hash
    instance
  end

  # persist the message
  def save!(uuid, auth_token)
    validate_state_transition!(uuid, auth_token)
    enqueue_message!(uuid, auth_token)
  end

  # validate on state API
  def validate_state_transition!(uuid, auth_token)
    AppLogger.log(self.class, "Validating messesage of type [#{self.class}]")
    # job = JobBuilder.new(message_type.to_s.gsub("Message", "Job")).job

    result = StateMachine.validate({self.class => message}, uuid, auth_token)
    raise Errors::RequestForbidden, "Incoming message failed patient state validation: #{result}" if result != 'true' # result should be set from http code - 200 if passed
  end

  # enqueue to processor API
  def enqueue_message!(uuid, auth_token)
    queue_name = Rails.configuration.environment.fetch('queue_name')
    Rails.logger.debug "Patient API publishing to queue: #{queue_name}..."
    Aws::Sqs::Publisher.publish(message, uuid, queue_name)
    # job.perform_later(message)
  end

  # convert 'SpecimenReceivedMessage' to 'specimen_received'; used in middleware
  def self.to_route_name
    to_s.underscore.chomp('_message')
  end

end

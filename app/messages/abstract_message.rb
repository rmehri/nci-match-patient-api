
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

end
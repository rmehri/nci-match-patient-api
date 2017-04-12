
class AbstractValidator
  include ActiveModel::Serializers::JSON

  class << self; attr_accessor :message_format end

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

end
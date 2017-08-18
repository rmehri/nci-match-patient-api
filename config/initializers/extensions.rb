# convert all values using the block operations
class Hash
  def deep_transform_values(&block)
    reduce({}) do |result, (k, v)|
      result[k] = v.is_a?(Hash) ? v.deep_transform_values(&block) : yield(v)
      result
    end
  end
end


# check if http respnse code is 2xx ok
class Integer
  def ok?
    (200..226).include? self
  end
end

# faster json processing
Oj.mimic_JSON

# extend base controller with authorize from ability.rb
# it is similar to authorize!, it returns true/false instead raising CanCan::AccessDenied
ActionController::Base.class_eval do
  def authorize(*args)
    current_ability.authorize(*args)
  end
end

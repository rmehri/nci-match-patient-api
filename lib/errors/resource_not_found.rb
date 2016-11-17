module Errors
  class ResourceNotFound < StandardError
    attr_reader :code

    def initialize(code = 404)
      @code = code
    end

    def to_s
      "[#{code}] #{super}"
    end

  end
end
module Errors
  class Unauthorized < StandardError
    attr_reader :code

    def initialize(code = 401)
      @code = code
    end

    def to_s
      "[#{code}] #{super}"
    end
  end
end

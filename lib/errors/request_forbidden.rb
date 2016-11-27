module Errors
  class RequestForbidden < StandardError
    attr_reader :code

    def initialize(code=403)
      @code = code
    end

    def to_s
      "[#{code}] #{super}"
    end

  end
end
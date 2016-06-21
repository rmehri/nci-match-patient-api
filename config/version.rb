module NciMatchPatientApi
  class Application < Rails::Application
    attr_reader :VERSION

    def VERSION
      @VERSION ||= "0.0.1"
    end
  end
end

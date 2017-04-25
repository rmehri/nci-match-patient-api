module V2
  class VersionsController < ApplicationController
    def show
      @hash = Hash.new
      begin
        File.read('build_number.html').each_line do | line |
          arr = line.to_s.split("=", 2)
          @hash.store(arr[0], arr[1])
        end
      rescue => error
        logger.error error
      end
      @hash.store("Version", NciMatchPatientApi::Application.version)
      @hash.store("Rails_version", Rails::VERSION::STRING)
      @hash.store("Ruby_version", RUBY_VERSION)
      @hash.store("Environment", Rails.env)
      render json: @hash
    end
  end
end

module V1
  class VersionsController < ApplicationController
    def version
      begin
        TestJob.set(wait: 1.minutes).perform_later("Hurray")
        File.open('build_number.html', 'r') do |document|
          hash = {}
          document.each_line do |line|
            arr = line.split('=', 2)
            hash.store(arr[0], arr[1].squish!)
          end
          document.close
          hash['Version'] = NciMatchPatientApi::Application.version
          hash['Rails Version'] = Rails::VERSION::STRING
          hash['Ruby Version'] = RUBY_VERSION
          hash['Environment'] = Rails.env
          render json: hash
        end
      rescue => error
        standard_error_message(error, 500)
      end
    end
  end
end

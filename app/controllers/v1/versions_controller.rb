module V1
  class VersionsController < ApplicationController
    def version
      begin
        File.open('build_number.html', 'r') do |document|
          result = {}
          document.each_line do |line|
            arr = line.split('=', 2)
            result.store(arr[0], arr[1].squish!)
          end
          document.close
          result['Build URL'] = "https://github.com/CBIIT/nci-match-patient-api/commit/#{result['Commit']}"
          result['Travis Build URL'] = "https://travis-ci.org/CBIIT/nci-match-patient-api/builds/#{result['TravisBuildID']}"
          result['Version'] = NciMatchPatientApi::Application.version
          result['Rails Version'] = Rails::VERSION::STRING
          result['Ruby Version'] = RUBY_VERSION
          result['Environment'] = Rails.env
          render json: result
        end
      rescue => error
        standard_error_message(error, 500)
      end
    end
  end
end

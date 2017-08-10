module NciPedMatchPatientApi

  class ServicesRoutesMiddleware
    def initialize(app)
      @app = app
    end

    # re-route a single to multiple routes based on input content: /api/v1/patients/:patient_id => /api/v1/patients/:patient_id/message_type_calculated_from_input_json
    # this way we replace ServicesController#trigger that handles many types with many methods where each handle a single type
    def call(env)

      # routes that are positive with regex match below: /api/v1/patients/:patient_id =~ /api/v1/patients/event
      # NOTE: patient_id should not contain this strings
      post_routes_to_skip = %w(events treatment_arms)

      # puts "REQUEST_METHOD: #{env['REQUEST_METHOD']}"
      # puts "PATH_INFO: #{env['PATH_INFO']}"
      # puts "HTTP_ACCEPT: #{env['HTTP_ACCEPT']}"
      # puts "HTTP_AUTHORIZATION: #{env['HTTP_AUTHORIZATION']}"

      # remove optional trailing segments
      env['PATH_INFO'].chomp!('/')
      env['PATH_INFO'].chomp!('.json')

      # skip if not POST or does not match /api/v1/patients/:patient_id, i.e. '/a/b/c/d' will match
      return @app.call(env) if env['REQUEST_METHOD'] != 'POST' || post_routes_to_skip.detect{|route| env['PATH_INFO'].include?(route)} || env['PATH_INFO'] !~ /^\/\w+[\/]\w+[\/]\w+[\/]\w+$/

      # puts "PATH_INFO after: #{env['PATH_INFO']}"

      # read input
      payload = JSON.parse(env['rack.input'].read)
      env['rack.input'].rewind

      # init message
      begin
        # get input type and check for its validity
        type = MessageFactory.get_message_type(payload.symbolize_keys)
      rescue => e
        # 404 not found, compatible with original handler - UnknownMessage#from_json will rise Errors::ResourceNotFound
        Rails.logger.info 'Building message failed.'
        return [404, {'Content-Type' => 'application/json'}, "#{e.message}"]
      end

      # validate message
      # 403 forbidden, compatible with original handler - Errors::RequestForbidden is used there
      # we also validate against schema in instance save! method, that should be triggered in v2 when this middleware is gone
      begin
        unless type.valid?
          msg = "#{type} message failed message schema validation: #{type.errors.messages}"
          Rails.logger.info msg
          return [403, {'Content-Type' => 'application/json'}, [msg]]
        end
      rescue => e
        # catch ArgumentError (invalid date and friends)
        # 400 bad request, compatible with original handler
        msg = "#{type} message failed message schema validation: #{e.message}"
        Rails.logger.info msg
        return [400, {'Content-Type' => 'application/json'}, [msg]]
      end

      # rewrite path
      new_path = "#{env['PATH_INFO']}/message/#{type.class.to_route_name}"
      env['PATH_INFO'] = env['REQUEST_URI'] = new_path

      # log re-route info
      Rails.logger.info "Route for ServiceController is rewritten for #{type.class} input: /api/v1/patients/:patient_id => #{new_path}"

      @app.call(env)
    end

  end
end

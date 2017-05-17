module PatientsDoc
  extend Apipie::DSL::Concern

  api :GET, '/patients', 'Lists all the Patiens Present in the Database'
  description <<-EOS
    === What this API Call does
      This API call Returns all the Patients present in the Database
    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def index
    # Nothing here, it's just a stub
  end
end

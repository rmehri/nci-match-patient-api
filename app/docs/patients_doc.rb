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

  api :GET, '/patients/:patient_id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def show
    # Nothing here, it's just a stub
  end

  api :POST, '/patients', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def create_
    # Nothing here, it's just a stub
  end

  api :PUT, '/patients/:patient_id/assignment_report_rollback', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def rollback_assignment_report
    # Nothing here, it's just a stub
  end

  api :PUT, '/patients/:patient_id/variant_report_rollback', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def rollback_variant_report
    # Nothing here, it's just a stub
  end

  api :PUT, '/patients/variant/:variant_uuid/:status', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def variant_status
    # Nothing here, it's just a stub
  end

  api :PUT, '/patients/:patient_id/assignment_reports/:analysis_id/:status', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def assignment_confirmation
    # Nothing here, it's just a stub
  end

  api :PUT, '/patients/:patient_id/variant_reports/:analysis_id/:status', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def variant_report_status
    # Nothing here, it's just a stub
  end

  api :POST, '/patients/:patient_id/variant_report/:molecular_id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def variant_report_uploaded
    # Nothing here, it's just a stub
  end

  api :POST, '/patients/:patient_id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def trigger
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/:patient_id/specimen_events', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def speciment_events_index
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/:patient_id/analysis_report/:analysis_id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def analysis_report_show
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/:patient_id/analysis_report_amois/:analysis_id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def analysis_report_amois_show
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/:patient_id/qc_variant_reports/:analysis_id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def qc_variant_reports_show
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/:patient_id/variant_file_download/:analysis_id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def variant_file_download_show
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/:patient_id/specimens/:specimen_id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def specimens_show
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/:patient_id/specimens', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def specimens_index
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/:patient_id/treatment_arm_history', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def treatment_arm_history_index
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/:patient_id/s3/:id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def s3_show
    # Nothing here, it's just a stub
  end

  api :POST, '/patients/:patient_id/s3', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def s3_create
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/:patient_id/s3', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def s3_index
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/:patient_id/action_items', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def action_items_index
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/healthz', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def health_check
    # Nothing here, it's just a stub
  end

  api :PATCH, '/patients/users', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def users_update
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/shipment_status/:id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def shipment_status_show
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/events/:id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def events_show
    # Nothing here, it's just a stub
  end

  api :POST, '/patients/events', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def events_create
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/events', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def events_index
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/assays', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def assays_index
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/specimens', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def specimens_index
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/patient_limbos', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def patient_limbos_index
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/shipments/:id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def shipments_show
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/shipments', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def shipments_index
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/assignments/:id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def assignments_show
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/assignments', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def assignments_index
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/variants/:id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def variants_show
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/variants', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def variants_index
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/variant_reports/:id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def variant_reports_show
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/variant_reports', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def variant_reports_index
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/:patient_id/assignment_report/:uuid', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def report_downloads_assignment_report_download
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/:patient_id/variant_report/:analysis_id', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def report_downloads_variant_report_download
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/amois', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def statistics_sequenced_and_confirmed_patients
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/pending_items', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def pending_view_pending_view
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/statistics', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def statistics_patient_statistics
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/version', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Response Format
      JSON
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def versions_version
    # Nothing here, it's just a stub
  end

  api :MATCH, '/*path', 'Handles the Malformed Requests Correctly'
  description <<-EOS
    === What this API Call does
      This API call handles the Bad Requests by returning a JSON response message
    === Response Format
      JSON
  EOS
  error code: 400, desc: 'Bad Request'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def bad_request
    # Nothing here, it's just a stub
  end
end

module PatientsDoc
  extend Apipie::DSL::Concern

  api :GET, '/patients', 'Lists all the Patiens Present in the Database'
  description <<-EOS
    === What this API Call does
      This API call returns all the patients present in the Database
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

  api :GET, '/patients?projections=[prop_key, prop_key]&attributes=[attr_key, attr_key]', 'Returns a list of only the Projection parameter field values for the Non Empty Attribute parameter for all the Patients'
  description <<-EOS
    === What this API Call does
       This API call accepts Projection & Attribute as the Query String Parameters and then returns a list of only the Projection parameter field value for the non empty Atrribute parameter for all the Patients present
    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      # Who is Authorized
    === Response Format
      JSON
    === Sample Request
      'http://localhost:10240/api/v1/patients?projections=[patient_id, current_status, current_step_number, registration_date]'
    === Sample Output
      [
        {
          'patient_id': PT_SC04d_TwoAssay,
          'registration_date': 2016-02-09T22:06:33+00:00,
          'current_step_number': 1.0,
          'current_status': ASSAY_RESULTS_RECEIVED
        },
        {
          'patient_id': ION_AQ04_TsShipped,
          'registration_date': 2016-02-09T22:06:33+00:00,
          'current_step_number': 1.0,
          'current_status': TISSUE_NUCLEIC_ACID_SHIPPED
        },
      ]
  EOS
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def index_
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/:patient_id', 'Returns data of the patient identified by patient_id'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      # Who is Authorized
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

  api :POST, '/patients/:patient_id', 'Post messages concerning the patient identified by patient_id'
  description <<-EOS
    === What this API Call does
      Create or update the patient identified by patient_id
    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      ADMIN
      PATIENT_MESSAGE_SENDER
      ASSAY_MESSAGE_SENDER
      SPECIMEN_MESSAGE_SENDER
      MOCHA_VARIANT_REPORT_SENDER
      MDA_VARIANT_REPORT_SENDER
      DARTMOUTH_VARIANT_REPORT_SENDER

    === Response Format
      {"message": "Message has been processed successfully"}

      {"message": "[Incoming message failed patient state validation: {\"error\":\"This patient has already been registered and cannot be registered again. \"}] Errors::RequestForbidden"}
  EOS
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def create_
    # Nothing here, it's just a stub
  end

  api :PUT, '/patients/:patient_id/variant_report_rollback', 'To rollback a patient state'
  description <<-EOS
    === What this API Call does
      To rollback a patient to TISSUE_VARIANT_REPORT_RECEIVED
    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      Only ADMIN is Authorized to access
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

  api :PUT, '/patients/variant/:variant_uuid/:status', 'To confirm / unconfirmed a variant'
  description <<-EOS
    === What this API Call does
      To confirm / unconfirmed a variant
    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      ADMIN
      MOCHA_VARIANT_REPORT_REVIEWER
      MDA_VARIANT_REPORT_REVIEWER
      DARTMOUTH_VARIANT_REPORT_REVIEWER
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

  api :PUT, '/patients/:patient_id/assignment_reports/:analysis_id/:status', 'To confirm a patient assignment'
  description <<-EOS
    === What this API Call does
      To confirm a patient assignment
    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      ADMIN
      ASSIGNMENT_REPORT_REVIEWER
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

  api :PUT, '/patients/:patient_id/variant_reports/:analysis_id/:status', 'To confirm / reject a variant report'
  description <<-EOS
    === What this API Call does
      To confirm / reject a variant report
    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      ADMIN
      MOCHA_VARIANT_REPORT_REVIEWER
      MDA_VARIANT_REPORT_REVIEWER
      DARTMOUTH_VARIANT_REPORT_REVIEWER
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

  api :POST, '/patients/:patient_id/variant_report/:molecular_id', 'To notify that a tsv is ready to be processed'
  description <<-EOS
    === What this API Call does
      To notify that a tsv is ready to be processed. IR Ecosystem calls this api when it completed converting a vcf to tsv.
      Example message body:
        {
          “ion_reporter_id”: “<ir_id>",
           “analysis_id”: “<analysis_id>",
          “tsv_file_name”: “xxx.tsv”
        }

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      ADMIN
      SYSTEM
      MOCHA_VARIANT_REPORT_SENDER
      MDA_VARIANT_REPORT_SENDER
      DARTMOUTH_VARIANT_REPORT_SENDER
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

  # api :POST, '/patients/:patient_id', 'Inserts a new Patient'
  # description <<-EOS
  #   === What this API Call does
  #     This API call takes a JSON body sent from COG, NCH, MDA, and IR Ecosystem as the input along with patient_id as the Parameter,
  #     Undergoes a couple of Validations and then puts the JSON on to the Queue to be consumed by the Patient Processor.
  #   === Authentication Required
  #     Auth0 token has to be passed as part of the request.
  #   === Authorization & Roles
  #     # Who is Authorized
  #   === Response Format
  #     JSON
  # EOS
  # param :patient_id, String, desc: 'ID of the Patient', required: true
  # error code: 401, desc: 'Unauthorized'
  # error code: 202, desc: 'Accepted'
  # error code: 500, desc: 'Internal Server Error'
  # error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'
  #
  # def trigger
  #   # Nothing here, it's just a stub
  # end

  api :GET, '/patients/:patient_id/specimen_events', '#Fill in description'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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

  api :GET, '/patients/:patient_id/treatment_arm_history', 'Returns the Treatment Arm History for a Patient.'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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

  api :GET, '/patients/:patient_id/action_items', 'Returns a list of Actions for a Patient.'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      # Who is Authorized
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

  api :GET, '/patients/healthcheck', 'Checks the Required Connections to the server'
  description <<-EOS
    === What this API Call does
      This API call Checks status of DynamoDB, S3 & SQS Connections to the Server and also returns the Queue name used by the Eco System
    === Authorization & Roles
      Authorization is NOT required
    === Response Format
      JSON
    === Sample Output
      {
        'dynamodb_connection': 'successful',
        'queue_name': 'sab_patient',
        'queue_connection': 'successful',
        's3_bucket_name': 'pedmatch-dev',
        's3_url': 'https://s3.amazonaws.com',
        's3_connection': 'successful'
      }
  EOS
  error code: 200, desc: 'Success (OK)'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def health_check
    # Nothing here, it's just a stub
  end

  api :PATCH, '/patients/users', 'To change password for a user account'
  description <<-EOS
    === What this API Call does
      Change password for a user account.
      Example message body:
        {“password”:“<your new password>“}
    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      ADMIN
      SPECIMEN_MESSAGE_SENDER
      PATIENT_MESSAGE_SENDER
      ASSAY_MESSAGE_SENDER
    === Response Format
      JSON
  EOS
  # param :patient_id, String, desc: 'ID of the Patient', required: true
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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
    === Authorization & Roles
      # Who is Authorized
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

  api :GET, '/patients/:patient_id/assignment_report/:uuid', 'Downloads the Assignment Report of a particular patient in Excel format'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      # Who is Authorized
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  param :uuid, String, desc: 'uuid of the Patient Assignment', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def report_downloads_assignment_report_download
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/:patient_id/variant_report/:analysis_id', 'Downloads the Variant Report of a particular patient in Excel format'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      # Who is Authorized
  EOS
  param :patient_id, String, desc: 'ID of the Patient', required: true
  param :analysis_id, String, desc: 'Analysis ID of the Patient', required: true
  error code: 401, desc: 'Unauthorized'
  error code: 200, desc: 'Success (OK)'
  error code: 500, desc: 'Internal Server Error'
  error code: 504, desc: 'Gateway Timeout (Usually occues when the Server is down)'

  def report_downloads_variant_report_download
    # Nothing here, it's just a stub
  end

  api :GET, '/patients/amois?confirmed=true&count=true', 'Returns a list of Patients with 0, 1, 2, 3, 4, 5+ amois'
  description <<-EOS
    === What this API Call does
      This API Call Returns a list of Patients with 0, 1, 2, 3, 4, 5+ amois. It also accepts the count query parameter which will provide the count for each category but when omitted it will return back a Patient object with information about the Tissue Report.
    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      # Who is Authorized
    === Response Format
      JSON
  EOS
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
    === Authorization & Roles
      # Who is Authorized
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

  api :GET, '/patients/statistics', 'Returns the Patient Statistics for the Clinical Trial.'
  description <<-EOS
    === What this API Call does

    === Authentication Required
      Auth0 token has to be passed as part of the request.
    === Authorization & Roles
      # Who is Authorized
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

  api :GET, '/patients/version', 'Checks the health of the server'
  description <<-EOS
    === What this API Call does
      This API call Checks the Health of the Server and also returns the Build Details
    === Authorization & Roles
      Authorization is NOT required
    === Response Format
      JSON
    === Sample Output
        {
          'TravisBuild': '381',
          'Commit': '2a14d4dc74c2dc9e5b36bc014187542192c64f50',
          'TravisBuildID': '184339872',
          'Author': 'Joey Verbeck <joseph.verbeck@nih.gov>',
          'BuildTime': '12-15-16-1433',
          'Docker': 'matchbox/nci-match-patient-api-api:12-15-16-1433',
          'Build URL': 'https://github.com/CBIIT/nci-match-patient-api/commit/2a14d4dc74c2dc9e5b36bc014187542192c64f50',
          'Travis Build URL': 'https://travis-ci.org/CBIIT/nci-match-patient-api/builds/184339872',
          'Version': '1.0.0',
          'Rails Version': '5.0.0.1',
          'Ruby Version': '2.3.1',
          'Environment': 'development'
        }
  EOS
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

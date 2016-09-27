module V1
  class PatientsController < ApplicationController
    # before_action :authenticate

    # GET /patients
    def patient_list
      begin
        render json: NciMatchPatientModels::Patient.scan({}).collect { |data| data.to_h }
      rescue => error
        standard_error_message(error.message)
      end
    end

    # GET /timeline
    def dashboard_timeline
      render_event_data
    end

    # GET /patients/1/pendingItems
    def pending_items
      render_pendging_items params[:patient_id]
    end

    # GET /api/v1/patients/1/timeline
    # GET /api/v1/patients/timeline?num={num_events}&order={asc | desc}
    def timeline
      render_event_patient_data params[:patient_id]
    end

    # GET /api/v1/patients/1
    # GET /api/v1/patients?basic={true | false}&disease={disease}&gender={gender}&ethnicity={ethnicity}
    def patient
      render_patient_data params[:patient_id]
    end

    # GET /api/v1/patients/variant_reports?status={PENDING | CONFIRMED | REJECTED}&type={TISSUE | BLOOD}
    def variant_reports
      begin
        type = params[:type].to_s.upcase
        status = params[:status].to_s.upcase
        dbm = NciMatchPatientModels::VariantReport.find_by({"status" => status, "variant_report_type" => type}).collect {|r| r}
        AppLogger.log_debug(self.class.name, "Got #{dbm.length} variant reports of type [#{type}]")
        reports = dbm.map { |x| x.to_h }
        render json: reports
      rescue => error
        standard_error_message(error.message)
      end
    end

    # GET /api/v1/patients/assignment_reports?status={PENDING | CONFIRMED}
    def assignment_reports
      status = params[:status].to_s.upcase

      begin
        dbm = NciMatchPatientModels::Assignment.find_by({"assignment_status" => status}).collect {|r| r}
        AppLogger.log_debug(self.class.name, "Got #{dbm.length} assignment reports")
        reports = dbm.map { |x| x.to_h }
        render json: reports
      rescue => error
        standard_error_message(error.message)
      end
    end

    #  GET /api/v1/patients/specimens?start_date={start_date}&end_date={end_date}
    def specimens
      render status: 200, json: '{"test":"specimens"}'
    end

    # GET /api/v1/patients/statistics
    def statistics
      begin
        patient_dbm = NciMatchPatientModels::Patient.find_by().collect {|r| r}
        AppLogger.log_debug(self.class.name, "Got #{patient_dbm.length} patients")
        totalPatients = patient_dbm.length
        patientsOnTreatmentArm_dbm = patient_dbm.select {|x| x.current_status == 'ON_TREATMENT_ARM'}
        patientsOnTreatmentArm = patientsOnTreatmentArm_dbm.length

        treatment_arm_accrual = Hash.new

        patientsOnTreatmentArm_dbm.select { |x| x.respond_to?('current_assignment') }.each do |x|
          # p x.current_assignment['assignment_logic']
          selected = x.current_assignment['assignment_logic'].detect {|a_l| a_l['reasonCategory'] == 'SELECTED'}
          if (selected != nil)
            taKey = selected['treatmentArmName'] + ' (' + selected['treatmentArmStratumId'] + ', ' + selected['treatmentArmVersion'] + ')'
            if (treatment_arm_accrual.has_key?(taKey))
              treatment_arm_accrual[taKey] = treatment_arm_accrual[taKey].patients + 1
            else
              treatment_arm_accrual[taKey] = {
                  "name" => selected['treatmentArmName'],
                  "stratum_id" => selected['treatmentArmStratumId'],
                  "patients" => 1
              }
            end

          end
        end
        variant_report_dbm = NciMatchPatientModels::VariantReport.find_by({"status" => "CONFIRMED", "variant_report_type" => "TISSUE"}).collect {|x| x.patient_id}.uniq
        AppLogger.log_debug(self.class.name, "Got #{variant_report_dbm.length} variant reports with status='CONFIRMED' and variant_report_type='TISSUE'")
        confirmedVrPatients = variant_report_dbm.length

        stats = {
            "number_of_patients" => totalPatients.to_s,
            "number_of_patients_on_treatment_arm" => patientsOnTreatmentArm.to_s,
            "number_of_patients_with_confirmed_variant_report" => confirmedVrPatients.to_s,
            "treatment_arm_accrual" => treatment_arm_accrual
        }

        render json: stats

      rescue => error
        standard_error_message(error.message)
      end
    end

    # GET /api/v1/patients/amois?confirmed=true&count=true
    def amois
      render status: 200, json: '{"test":"test"}'
    end

    # GET /api/v1/patients/{patient_id}/specimens
    def patient_specimens
      render status: 200, json: '{"test":"patient_specimens"}'
    end

    # GET /api/v1/patients/{patient_id}/variant_reports/{molecular_id}/{analysis_id}?filtered={true|false}
    #  Returns one report
    def patient_variant_report
      render status: 200, json: '{"test":"patient_variant_report"}'
    end

    # GET /api/v1/patients/{patient_id}/variant_reports?type={BLOOD|TISSUE}&status={PENDING | CONFIRMED | REJECTED}
    # return a list
    def patient_variant_reports
      render status: 200, json: '{"test":"patient_variant_reports"}'
    end

    # GET /api/v1/patients/{patient_id}/assignment_reports?status={PENDING | CONFIRMED}
    def patient_assignment_reports
      render status: 200, json: '{"test":"patient_assignment_reports"}'
    end

    # GET /api/v1/patients/{patient_id}/assignment_reports/{date_assigned}
    def patient_assignment_report
      render status: 200, json: '{"test":"patient_assignment_report"}'
    end

    # GET /api/v1/patients/{patient_id}/samples/{analysis_id}?format=zip
    def sample_files
      render status: 200, json: '{"test":"sample_files"}'
    end

    # GET /api/v1/patients/{patient_id}/samples/{analysis_id}/{filename}
    def sample_file
      render status: 200, json: '{"test":"Get sample_file"}'
    end

    # GET /api/v1/patients/shipments
    def shipments
      begin

        shipment_dbms = NciMatchPatientModels::Shipment.query_history
        AppLogger.log_debug(self.class.name, "Got #{shipment_dbms.length} specimens")

        shipment_uims = []

        shipment_dbms.each do |shipment_dbm|
          shipment_uim = shipment_dbm.to_h
          shipment_uims.push shipment_uim

          specimen_dbms = NciMatchPatientModels::Specimen
                              .find_by({"patient_id" => shipment_dbm.patient_id, "surgical_event_id" => shipment_dbm.surgical_event_id})
                              .collect {|r| r}

          if (specimen_dbms.length > 0)

            shipment_uim['assays'] = specimen_dbms[0].assays if specimen_dbms[0].assays.present? if shipment_dbm.type != 'SLIDE'
            shipment_uim['collected_date'] = specimen_dbms[0].collected_date if specimen_dbms[0].collected_date.present?
            shipment_uim['received_date'] = specimen_dbms[0].received_date if specimen_dbms[0].received_date.present?
            shipment_uim['pathology_status'] = specimen_dbms[0].pathology_status if specimen_dbms[0].pathology_status.present?
            shipment_uim['pathology_status_date'] = specimen_dbms[0].pathology_status_date if specimen_dbms[0].pathology_status_date.present?

          end
        end

        render json: shipment_uims
      rescue => error
        standard_error_message(error.message)
      end
    end

    # GET /api/v1/patients/sequencedAndConfirmedPatients
    # TODO: this should be merged in /statistics
    def sequenced_and_confirmed_patients
      begin

        report_dbm = NciMatchPatientModels::VariantReport.find_by({"status" => "CONFIRMED", "variant_report_type" => "TISSUE"}).collect {|x| x}.uniq
        AppLogger.log_debug(self.class.name, "Got #{report_dbm.length} variant reports with status='CONFIRMED' and variant_report_type='TISSUE'")

        stats = {
            "patients_with_0_amois" => report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois == 0}.to_s,
            "patients_with_1_amois" => report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois == 1}.to_s,
            "patients_with_2_amois" => report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois == 2}.to_s,
            "patients_with_3_amois" => report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois == 3}.to_s,
            "patients_with_4_amois" => report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois == 4}.to_s,
            "patients_with_5_or_more_amois" =>report_dbm.count { |x| x.total_confirmed_amois.present? && x.total_confirmed_amois >= 5}.to_s
        }

        render json: stats
      rescue => error
        standard_error_message(error.message)
      end
    end

    # GET /patients/:patientid/sampleHistory/:sampleid
    def sample
      render status: 200, json: '{"test":"test"}'
    end

    # GET /patients/:patientid/qcVariantReport/:sampleid/:type
    def qc_variant_report
      render status: 200, json: '{"test":"qc_variant_report"}'
    end

    # POST /patients/:patientid/sampleFile
    def upload_sample_file
      render status: 200, json: '{"test":"POST sample_file"}'
    end

    # # PUT /api/v1/patients/{patient_id}/variant_reports/{molecular_id}/{analysis_id}/{confirm|reject}
    # def variant_status
    #
    #   # first get {confirm|reject}
    #
    #   begin
    #     patient_id = get_patient_id_from_url
    #     input_data = get_post_data(patient_id)
    #     # input_data = get_post_data
    #
    #     result = ConfirmResult.from_json input_data
    #
    #     p result.to_h
    #
    #     # response_json = PatientProcessor.run_service("/confirm_variant", input_data)
    #
    #     # AppLogger.log(self.class.name, "\nResponse from Patient Processor: #{response_json}")
    #     # standard_success_message(JSON.parse(response_json)['message'])
    #
    #   rescue => error
    #     standard_error_message(error.message)
    #   end
    # end


    # # PUT /api/v1/patients/{patient_id}/assignment_reports/{date_assigned}/confirm
    # def assignment_confirmation
    #   begin
    #     patient_id = get_patient_id_from_url
    #     message = get_post_data(patient_id)
    #
    #     type = MessageValidator.get_message_type(message)
    #     raise "Incoming message has UNKNOWN message type" if (type == 'UNKNOWN')
    #
    #     error = MessageValidator.validate_json_message(type, message)
    #     raise "Incoming message failed message schema validation: #{error}" if !error.nil?
    #     p "=========== input data: #{message}"
    #
    #     success = validate_patient_state(message, type)
    #     result = PatientProcessor.run_service('/confirmAssignment', message)
    #     standard_success_message(result)
    #   rescue => error
    #     standard_error_message(error.message)
    #   end
    # end

    # GET /api/v1/patients/specimens/{molecular_id}/specimen_shipped
    def specimen_shipped
      render status: 200, json: '{"test":"specimen_shipped"}'
    end

    # POST /patientStatus
    def patient_status
      process_message
    end

    # GET /api/v1/patients/{patient_id}/documents
    def document_list
      # return zip file by default for now
      render status: 200, json: '{"test":"document_list"}'
    end

    # GET /api/v1/patients/{patient_id}/documents/{document_id}?format=zip
    def document
      render status: 200, json: '{"test":"document"}'
    end

    # POST /patients/:patientid/documents
    def new_document
      render status: 200, json: '{"test":"new_document"}'
    end


    private

    def scan(record, patientid)
      begin
        record.scan(
            :scan_filter => {
                "patient_id" => {
                    :comparison_operator => "EQ",
                    :attribute_value_list => patientid
                }
            }
        )
      rescue Aws::DynamoDB::Errors::ResourceNotFoundException => error1
        p error1
        standard_error_message(error1)
      rescue => error2
        p error2
        raise
      end
    end

    def render_event_data
      begin

        events_dbm = NciMatchPatientModels::Event.query_top 10

        AppLogger.log_debug(self.class.name, "Got #{events_dbm.count} events for dashboard") if !events_dbm.nil?
        events = events_dbm.map { |e_dbm| e_dbm.to_h }
        render json: events

      rescue => error
        standard_error_message(error.message)
      end
    end

    def render_pendging_items(patientid)
      # This should be included in patient ui model
      begin
        pending_items = []

        variant_report_dbms = NciMatchPatientModels::VariantReport.find_by({"status" => "PENDING", "patient_id" => params[:patientid]}).collect {|r| r}
        AppLogger.log_debug(self.class.name, "Got #{variant_report_dbms.length} variant reports for patient [#{params[:patientid]}]")

        variant_report_dbms.collect { |x| x }.each do |variant_report_dbm|
          pending_items.push ({
              "action_type" => variant_report_dbm.variant_report_type == 'TISSUE' ? 'pending_tissue_variant_report' : 'pending_blood_variant_report',
              "title" => variant_report_dbm.variant_report_type == 'TISSUE' ? 'Pending Tissue Variant Report' : 'Pending Blood Variant Report',
              "molecular_id" => variant_report_dbm.molecular_id,
              "analysis_id" => variant_report_dbm.analysis_id,
              "created_date" => variant_report_dbm.status_date.to_s
          })
        end

        assignment_report_dbms = NciMatchPatientModels::Assignment.find_by({"status" => "PENDING", "patient_id" => params[:patientid]}).collect {|r| r}
        AppLogger.log_debug(self.class.name, "Got #{assignment_report_dbms.length} assignment reports for patient [#{params[:patientid]}]")

        assignment_report_dbms.collect { |x| x }.each do |assignment_report_dbm|
          pending_items.push ({
              "action_type" => 'pending_assignment_report',
              "title" => 'Pending Assignment Report',
              "molecular_id" => assignment_report_dbm.molecular_id,
              "analysis_id" => assignment_report_dbm.analysis_id,
              "created_date" => assignment_report_dbm.status_date.to_s
          })
        end

        render json: pending_items
      rescue => error
        standard_error_message(error.message)
      end
    end

    def render_event_patient_data(patientid)
      begin
        events_dbm = NciMatchPatientModels::Event.query_events_by_entity_id(patientid, false).collect {|r| r}
        AppLogger.log_debug(self.class.name, "Got #{events_dbm.count} events for patient #{patientid}") if !events_dbm.nil?

        events = events_dbm.map { |e_dbm| e_dbm.to_h }
        render json: events
      rescue => error
        standard_error_message(error.message)
      end
    end

    def render_patient_data(patient_id)
      begin

        patient_dbm = NciMatchPatientModels::Patient.query_patient_by_id(patient_id)
        raise "Unable to find patient #{patient_id}" if patient_dbm.nil?

        AppLogger.log_debug(self.class.name, "Found patient [#{patient_id}]")

        specimens_dbm = NciMatchPatientModels::Specimen.query_specimens_by_patient_id(patient_id, false).collect {|r| r}
        AppLogger.log_debug(self.class.name, "Got #{specimens_dbm.length} specimens for patient [#{patient_id}]")

        shipments_dbm = NciMatchPatientModels::Shipment.find_by({"patient_id" => patient_id}).collect {|r| r}
        AppLogger.log_debug(self.class.name, "Found #{shipments_dbm.length} total shipments for patient [#{patient_id}]")

        variant_reports_dbm = get_variant_reports(patient_id)
        variants_dbm = get_variants_for_reports(variant_reports_dbm)

        uim = Convert::PatientDbModel.to_ui_model patient_dbm, variant_reports_dbm, variants_dbm, specimens_dbm, shipments_dbm
        render json: uim

      rescue => error
        standard_error_message(error.message)
      end
    end

    def valid_test_message
      {:valid => true}
    end

    def invalid_test_message
      {:valid => false}
    end

    def process_message(*message_type)
      if validate_and_queue(message_type)
        render_validation_success
      else
        render_validation_failure;
      end
    end

    def render_validation_success
      render status: 200, json: {:status => "Success"}
    end

    def render_validation_failure
      render status: 400, json: {:status => "Failure", :message => "Validation failed. Please check all required fields are present"}
    end

    # def get_post_data
    #   json_data = JSON.parse(request.raw_post)
    #   AppLogger.log_debug(self.class.name, "Patient API received message: #{json_data.to_json}")
    #   json_data.deep_transform_keys!(&:underscore).symbolize_keys!
    #   json_data
    # end

    # def validate(message)
    #   type = MessageValidator.get_message_type(message)
    #   raise "Incoming message has UNKNOWN message type" if (type == 'UNKNOWN')
    #
    #   error = MessageValidator.validate_json_message(type, message)
    #   raise "Incoming message failed message schema validation: #{error}" if !error.nil?
    #
    #   status = validate_patient_state_no_queue(message, type)
    #   raise "Incoming message failed patient state validation" if (status == false)
    #   true
    # end

    # def validate_patient_state_no_queue(message, message_type)
    #
    #   AppLogger.log(self.class.name, "Validating messesage of type [#{message_type}]")
    #
    #   message_type = {message_type => message}
    #   p message_type
    #   result = StateMachine.validate(message_type)
    #
    #   if result != 'true'
    #     result_hash = JSON.parse(result)
    #     raise "Incoming message failed patient state validation: #{result_hash['error']}"
    #   end
    #
    #   true
    # end

    # def validate_and_queue(*message_type)
    #
    #   AppLogger.log_debug(self.class.name, "Message_type val: #{message_type}")
    #
    #   message = get_post_data
    #   message_type = {message_type[-1][-1] => message}
    #   Rails.logger.debug "Message type: #{message_type}"
    #
    #   res = StateMachine.validate(message_type)
    #   Rails.logger.debug "Response from StateMachine: #{res}"
    #   if res == "true"
    #     queue_name = ENV['queue_name']
    #     Rails.logger.debug "Patient API publishing to queue: #{queue_name}..."
    #     Aws::Sqs::Publisher.publish(message, queue_name)
    #     return true
    #   else
    #     return false
    #   end
    # end

    def get_variant_reports(patient_id)
      variant_reports_dbm = NciMatchPatientModels::VariantReport.query_by_patient_id(patient_id, false).collect {|r| r}

      AppLogger.log_debug(self.class.name, "Patient [#{patient_id}] has #{variant_reports_dbm.length} variant reports")
      variant_reports_dbm
    end

    def get_variants_for_reports(variant_reports_dbm)
      variants_dbm = []
      variant_reports_dbm.each do |variant_report_dbm|
        variants = NciMatchPatientModels::Variant.find_by({"patient_id" => variant_report_dbm.patient_id,
                                                           "molecular_id" => variant_report_dbm.molecular_id,
                                                           "analysis_id" => variant_report_dbm.analysis_id}).collect {|r|
          p "======== v: #{r.to_h}"
          r}
        variants_dbm.push(*variants)
      end

      AppLogger.log_debug(self.class.name,
                          "Patient has a total of #{variants_dbm.length} variants from #{variant_reports_dbm.length} variant reports")
      variants_dbm
    end

  end
end
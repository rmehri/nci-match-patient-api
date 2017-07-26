module V1
  class PatientLimbosController < BaseController
    before_action :set_resource, only: [:index]

    def index
      render json: instance_variable_get("@#{resource_name}")
    end

    private

    def target_statuses
      ["TISSUE_SPECIMEN_RECEIVED",
       "TISSUE_NUCLEIC_ACID_SHIPPED",
       "TISSUE_SLIDE_SPECIMEN_SHIPPED",
       "ASSAY_RESULTS_RECEIVED",
       "TISSUE_VARIANT_REPORT_RECEIVED",
       "TISSUE_VARIANT_REPORT_REJECTED",
       "TISSUE_VARIANT_REPORT_CONFIRMED",
       "PENDING_CONFIRMATION",
       "PENDING_APPROVAL",
       "AWAITING_PATIENT_DATA",
       "AWAITING_TREATMENT_ARM_STATUS"]
    end

    def set_resource(_resource = {})
      # non_target_statuses = ["REGISTRATION", "ON_TREATMENT_ARM", "REQUEST_ASSIGNMENT", "REQUEST_NO_ASSIGNMENT", "OFF_STUDY", "OFF_STUDY_BIOPSY_EXPIRED"]
      resources = NciMatchPatientModels::Patient.scan({:attributes_to_get => ["active_tissue_specimen", "patient_id", "current_status", "diseases", "assignment_error"],
                                                       :scan_filter => {"current_status" => {:comparison_operator => "IN", :attribute_value_list => target_statuses},
                                                                        "active_tissue_specimen" => {:comparison_operator => "NOT_NULL"}}}).collect { |data| data.to_h.compact.deep_symbolize_keys! }

      #TODO: filter out elements that we don't show
      resources = resources.select{ |resource| !(resource[:active_tissue_specimen][:specimen_received_date].nil?)}
      resources.uniq!{ |resource| resource[:patient_id] }
      instance_variable_set("@#{resource_name}", generate_messages(resources))
    end

    def generate_messages(resources)
      final_resources = []
      resources.each do | patient |
        messages = []
        active_tissue_specimen = patient[:active_tissue_specimen]

        messages.push(*get_variant_report_message(active_tissue_specimen))
        messages.push(*get_assay_messages(active_tissue_specimen))

        messages << "Assignment report pending confirmation" if patient[:current_status] == 'PENDING_CONFIRMATION'
        messages << "Assignment report awaiting approval from COG" if patient[:current_status] == 'PENDING_APPROVAL'
        messages << patient[:assignment_error] unless patient[:assignment_error].nil?


        patient[:message] = messages
        patient[:days_pending] = (Date.current - Date.parse(active_tissue_specimen[:specimen_received_date])).to_i

        final_resources << patient
      end

      final_resources
    end

    def get_variant_report_message(active_tissue_specimen)
      vr_message = []
      if active_tissue_specimen[:active_molecular_id].nil?
        vr_message << "Tissue DNA and RNA shipment missing"
      elsif active_tissue_specimen[:active_analysis_id].nil? ||
          (!active_tissue_specimen[:variant_report_status].nil? && active_tissue_specimen[:variant_report_status] == 'REJECTED')
        vr_message << "Variant report missing"
      elsif (active_tissue_specimen[:variant_report_status].nil? || active_tissue_specimen[:variant_report_status] != 'CONFIRMED')
        vr_message << "No confirmed variant report"
      end
      vr_message
    end

    def get_assay_messages(active_tissue_specimen)
      assay_messages = []
      if (active_tissue_specimen[:slide_shipped_date].nil?)
        assay_messages << "Slide shipment missing"
      else
        Rails.configuration.assay.collect do |k, v|
          if (Date.parse(v["start_date"]) <= Date.current) && ((v["end_date"].blank? || Date.current < Date.parse(v["end_date"])))
            if (active_tissue_specimen[k.to_sym].nil?)
              gene_name = ApplicationHelper.to_gene_name(k.to_s)
              assay_messages << "#{gene_name} assay result missing"
            end
          end
        end
      end
      assay_messages
    end
  end

end
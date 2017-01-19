module V1
  class PatientLimbosController < BaseController
    before_action :set_resource, only: [:index]

    def index
      render json: instance_variable_get("@#{resource_name}")
    end

    private
    def set_resource(_resource = {})
      # non_target_statuses = ["REGISTRATION", "TISSUE_VARIANT_REPORT_CONFIRMED", "PENDING_CONFIRMATION", "ON_TREATMENT_ARM", "REQUEST_ASSIGNMENT", "REQUEST_NO_ASSIGNMENT", "OFF_STUDY", "OFF_STUDY_BIOPSY_EXPIRED"]
      target_statuses = ["TISSUE_SPECIMEN_RECEIVED",
                         "TISSUE_NUCLEIC_ACID_SHIPPED",
                         "TISSUE_SLIDE_SPECIMEN_SHIPPED",
                         "ASSAY_RESULTS_RECEIVED",
                         "TISSUE_VARIANT_REPORT_RECEIVED",
                         "TISSUE_VARIANT_REPORT_REJECTED",
                         "PENDING_APPROVAL",
                         "AWAITING_PATIENT_DATA",
                         "AWAITING_TREATMENT_ARM_STATUS"]

      resources = NciMatchPatientModels::Patient.scan({:attributes_to_get => ["active_tissue_specimen", "patient_id", "current_status", "diseases", "message"],
                                                       :scan_filter => {"current_status" => {:comparison_operator => "IN", :attribute_value_list => target_statuses},
                                                                        "active_tissue_specimen" => {:comparison_operator => "NOT_NULL"}}}).collect { |data| data.to_h.compact.deep_symbolize_keys! }

      resources.collect{ |resource| (Date.current - Date.parse(resource[:active_tissue_specimen][:specimen_collected_date])).to_i >= 7 }
      resources.uniq!{ |resource| resource[:patient_id] }
      generate_messages(resources)
      instance_variable_set("@#{resource_name}", resources)
    end

    def generate_messages(resources)
      resources.each do | patient |
        messages = []
        active_tissue_specimen = patient[:active_tissue_specimen]

        if active_tissue_specimen[:active_molecular_id].nil?
          messages << "Tissue shipment missing"
        elsif active_tissue_specimen[:active_analysis_id].nil?
          messages << "Variant report missing"
        end

        add_assay_messages(active_tissue_specimen, messages)

        if (active_tissue_specimen[:variant_report_status].nil? || active_tissue_specimen[:variant_report_status] != 'CONFIRMED')
          messages << "No confirmed variant report"
        end

        unless patient[:message].nil?
          messages << patient[:message]
        end

        if patient[:current_status] == 'PENDING_APPROVAL'
          messages << "Assignment report awaiting approval from COG"
        end

        patient[:message] = messages
        patient[:days_pending] = (Date.current - Date.parse(active_tissue_specimen[:specimen_collected_date])).to_i
      end

    end

    def add_assay_messages(active_tissue_specimen, messages)

      if (active_tissue_specimen['slide_shipped_date'].nil?)
        messages << "Slide shipment missing"
      else
        Rails.configuration.assay.collect do |k, v|
          if (Date.parse(v["start_date"]) <= Date.current) && (Date.current <= Date.parse(v["end_date"]))
            if (active_tissue_specimen[k.to_sym].nil?)
              messages << "#{k.to_s} assay result missing"
            end
          end
        end

      end

    end
  end

end
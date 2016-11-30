module V1
  class PatientLimbosController < BaseController
    before_action :set_resource, only: [:index]

    def index
      render json: instance_variable_get("@#{resource_name}")
    end

    private
    def set_resource(resource = {})
      non_target_statuses = ["REGISTRATION", "ON_TREATMENT_ARM", "REQUEST_NO_ASSIGNMENT", "OFF_STUDY", "OFF_STUDY_BIOPSY_EXPIRED"]
      resources = NciMatchPatientModels::Patient.scan({:attributes_to_get => ["active_tissue_specimen", "patient_id", "current_status", "diseases", "message"],
                                                       :scan_filter => {
                                                       "active_tissue_specimen" => {:comparison_operator => "NOT_NULL"}}}).collect { |data| data.to_h.compact.deep_symbolize_keys! }

      resources.collect{ |resource| (Date.current - Date.parse(resource[:active_tissue_specimen][:specimen_collected_date])).to_i >= 2 }
      resources.collect{ |resource| (!(non_target_statuses.include? (resource[:current_status])))}

      resources.uniq!{ |resource| resource[:patient_id] }
      generate_messages(resources)
      instance_variable_set("@#{resource_name}", resources)
    end

    def generate_messages(resources)
      resources.each do | patient |
        messages = []
        active_tissue_specimen = patient[:active_tissue_specimen]

        if (active_tissue_specimen[:active_molecular_id].nil?)
          messages << "tissue shipment missing"
        elsif active_tissue_specimen[:active_analysis_id].nil?
          messages << "variant report missing"
        end

        if (active_tissue_specimen[:slide_shipped_date].nil?)
          messages << "slide shipment missing"
        else
          if (active_tissue_specimen[:ICCMLH1s].nil?)
              messages << "MLH1 assay result missing"
          end

          if (active_tissue_specimen[:ICCPTENs].nil?)
            messages << "PTEN assay result missing"
          end
        end

        if (active_tissue_specimen[:variant_report_status].nil? || active_tissue_specimen[:variant_report_status] != 'CONFIRMED')
          messages << "no confirmed variant report"
        end

        if (!patient[:message].nil?)
          messages << patient[:message]
        end

        if (patient[:current_status] == 'PENDING_CONFIRMATION')
          messages << "assignment report awaiting review"
        end

        if (patient[:current_status] == 'PENDING_APPROVAL')
          messages << "assignment report awaiting approval from COG"
        end

        patient[:message] = messages
        patient[:days_pending] = (Date.current - Date.parse(active_tissue_specimen[:specimen_collected_date])).to_i
      end

    end

  end
end
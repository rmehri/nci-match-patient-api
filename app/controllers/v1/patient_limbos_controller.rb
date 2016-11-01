module V1
  class PatientLimbosController < BaseController
    before_action :set_resource, only: [:index]

    def index
      render json: instance_variable_get("@#{resource_name}")
    end

    private
    def set_resource(resource = {})
      resources = NciMatchPatientModels::Patient.scan({:attributes_to_get => ["active_tissue_specimen", "patient_id", "current_status"],
                                                       :scan_filter => {"current_status" => {:comparison_operator => "IN", :attribute_value_list =>["AWAITING_PATIENT_DATA", "AWAITING_TREATMENT_ARM_STATUS"]},
                                                       "active_tissue_specimen" => {:comparison_operator => "NOT_NULL"}}}).collect { |data| data.to_h.compact.deep_symbolize_keys! }

      resources.collect{ |resource| (Date.current - Date.parse(resource[:active_tissue_specimen][:slide_shipped_date])).to_i >= 2 }
      instance_variable_set("@#{resource_name}", resources)
    end

  end
endgit
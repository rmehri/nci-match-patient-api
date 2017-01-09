module V1
  class AssaysController < BaseController
    before_action :set_resource, only: [:index]

    def index
      render json: instance_variable_get("@#{resource_name}")
    end

    private
    def set_resource(_resource = {})
      assays = []
      specimens = NciMatchPatientModels::Specimen.find_by({:specimen_type => 'TISSUE'})
      specimens.each do | specimen|
        next if specimen.assays.nil?
        assays.push(*merge_assay_hash(specimen))
      end

      instance_variable_set("@#{resource_name}", assays)
    end

    def merge_assay_hash(specimen)
      assays = []
      specimen.assays.each do |assay|
        specimen_assay = assay.clone
        specimen_assay[:patient_id] = specimen.patient_id
        specimen_assay[:surgical_event_id] = specimen.surgical_event_id
        assays << specimen_assay
      end

      assays
    end
  end
end

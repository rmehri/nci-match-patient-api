module V1
  class ShipmentsController < BaseController

    private
    def shipments_params
      build_query({:molecular_id => params.require(:id)})
    end

    def query_params
      # TODO: 3 molecular IDs? There is only 1 that I know of.
      parameters = params.permit(:uuid, :shipped_date, :patient_id, :surgical_event_id, :molecular_id, :slide_barcode,
                                 :study_id, :type, :molecular_dna_id, :molecular_cdna_id, :carrier, :tracking_id,
                                 :destination, :dna_volume_ul, :dna_concentration_ng_per_ul, :cdna_volume_ul,
                                 :attributes, :projections, :projection => [], :attribute => [])
      build_query(parameters)
    end
  end
end
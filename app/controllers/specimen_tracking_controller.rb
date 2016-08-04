class SpecimenTrackingController < ApplicationController
  # before_action :authenticate

  # GET /specimenTracking/shipments
  def shipments
    begin

      shipment_dbm = NciMatchPatientModels::Shipment.query_history
      AppLogger.log_debug(self.class.name, "Got #{shipment_dbm.length} specimens")

      uims = []

      shipment_dbm.each do |x|
        uim = x.data_to_h
        uims.push uim

        specimen_dbm = NciMatchPatientModels::Specimen.find_by({"patient_id" => x.patient_id, "surgical_event_id" => x.surgical_event_id}).collect {|r| r}
        
        if (specimen_dbm.length > 0)

          uim['assays'] = specimen_dbm[0].assays if specimen_dbm[0].assays.present?
          uim['collected_date'] = specimen_dbm[0].collected_date if specimen_dbm[0].collected_date.present?
          uim['received_date'] = specimen_dbm[0].received_date if specimen_dbm[0].received_date.present?
          uim['type'] = specimen_dbm[0].type if specimen_dbm[0].type.present?
          uim['pathology_status'] = specimen_dbm[0].pathology_status if specimen_dbm[0].pathology_status.present?
          uim['pathology_status_date'] = specimen_dbm[0].pathology_status_date if specimen_dbm[0].pathology_status_date.present?
          
        end
      end

      render json: uims
    rescue => error
      standard_error_message(error.message)
    end
  end

end

# Shipment model
#     string_attr :uuid, hash_key: true
#     datetime_attr :shipped_date, range_key: true

#     string_attr :patient_id
#     string_attr :surgical_event_id
#     string_attr :molecular_id
#     string_attr :slide_barcode
#     string_attr :study_id
#     string_attr :type

#     string_attr :molecular_dna_id
#     string_attr :molecular_cdna_id

#     string_attr :carrier
#     string_attr :tracking_id
#     string_attr :destination

# Specimen model
#     string_attr :patient_id, hash_key: true
#     datetime_attr :collected_date, range_key: true

#     string_attr :surgical_event_id
#     datetime_attr :failed_date
#     string_attr :study_id
#     string_attr :type
#     datetime_attr :received_date

#     string_attr :pathology_status
#     datetime_attr :pathology_status_date

#     datetime_attr :variant_report_confirmed_date
#     string_attr :active_molecular_id

#     list_attr :assays

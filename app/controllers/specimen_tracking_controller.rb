class SpecimenTrackingController < ApplicationController
  # before_action :authenticate

  # GET /specimenTracking/shipments
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

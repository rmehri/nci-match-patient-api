
class VariantReportMessage < AbstractMessage
  include MessageValidator::VariantReportValidator

  @message_format =/:analysis_id/

  attr_accessor :ion_reporter_id,
                :patient_id,
                :molecular_id,
                :analysis_id,
                :tsv_file_name

  # override factory method to set missing key from input
  def self.from_hash(hash)
    # set patient_id using molecular_id
    shipments = NciMatchPatientModels::Shipment.scan_and_find_by({molecular_id: hash['molecular_id']})
    raise Errors::RequestForbidden, "Unable to find shipment with molecular id [#{hash['molecular_id']}]" if shipments.blank? # true for nil, false, '', {}, []
    hash['patient_id'] = shipments[0]['patient_id']
    super(hash)
  end
end

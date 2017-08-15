class AmoisAnalysisReport
  attr_accessor :variant_report, :variant_report_hash, :updated_mois, :amoi_count

  # init state
  def initialize(variant_report, mois_from_rule)
    self.variant_report = variant_report
    self.variant_report_hash = variant_report.to_h.deep_symbolize_keys!
    self.updated_mois = mois_from_rule.deep_dup # do not mutate input
    self.amoi_count = 0
  end

  # set amois count and uuids; update variant_report
  def update_mois!
    self.update_mois_groups
    return if variant_report.total_amois == amoi_count # no count change
    variant_report.total_amois = amoi_count
    variant_report.save
    AppLogger.log(self.class.name, "Amoi count updated for patient [#{variant_report.patient_id}]")
  end

  # process each mois group
  def update_mois_groups
    count_amois_and_set_uuids(updated_mois[:snv_indels])
    count_amois_and_set_uuids(updated_mois[:copy_number_variants])
    count_amois_and_set_uuids(updated_mois[:gene_fusions])
  end

  # count and set uuid
  def count_amois_and_set_uuids(mois_group)
    return if mois_group.blank?

    mois_group.each do | moi |
      next if moi[:amois].blank?

      # increment count if amoi is found
      self.amoi_count += 1

      # build query params to get variant for uuid
      query_hash = {  patient_id:   variant_report_hash[:patient_id],
                      molecular_id: variant_report_hash[:molecular_id],
                      analysis_id:  variant_report_hash[:analysis_id],
                      variant_type: moi[:variant_type]}
      query_hash[:surgical_event_id] = variant_report_hash[:surgical_event_id] if variant_report_hash[:surgical_event_id].present?
      %i(identifier func_gene chromosome position reference alternative driver_gene partner_gene).each do |moi_attr|
        query_hash[moi_attr] = moi[moi_attr] if moi[moi_attr].present?
      end

      # set uuid
      variants = NciMatchPatientModels::Variant.find_by(query_hash).collect { |data| data.to_h.compact }
      moi[:uuid] = variants[0][:uuid] if (variants.length > 0)
    end
  end
end

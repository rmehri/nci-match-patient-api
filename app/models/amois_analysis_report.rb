class AmoisAnalysisReport
  attr_accessor :variant_report, :variant_report_hash, :mois, :amoi_count

  # init state
  def initialize(variant_report, mois)
    self.variant_report = variant_report
    self.variant_report_hash = variant_report.to_h.deep_symbolize_keys!
    self.mois = mois
    self.amoi_count = 0
  end

  # update count in variant_report if its changed
  def update_amoi_count_in_variant_report!
    self.count_amois
    return if variant_report.total_amois == amoi_count # no count change
    variant_report.total_amois = amoi_count
    variant_report.save
    AppLogger.log(self.class.name, "Amoi count updated for patient [#{variant_report.patient_id}]")
  end

  # total count is count in each amoi group
  def count_amois
    self.amoi_count  = find_amoi_count_by_uuid(mois[:snv_indels])
    self.amoi_count += find_amoi_count_by_uuid(mois[:copy_number_variants])
    self.amoi_count += find_amoi_count_by_uuid(mois[:gene_fusions])
  end

  # group count by matching mois with uuid
  def find_amoi_count_by_uuid(mois_group)
    amoi_count = 0
    return amoi_count if mois_group.blank?

    mois_group.each do | moi |
      next if moi[:amois].blank?

      amoi_count += 1
      query_hash = {  patient_id:   variant_report_hash[:patient_id],
                      molecular_id: variant_report_hash[:molecular_id],
                      analysis_id:  variant_report_hash[:analysis_id],
                      variant_type: moi[:variant_type]}

      query_hash[:surgical_event_id] = variant_report_hash[:surgical_event_id] if variant_report_hash[:surgical_event_id].present?
      %i(identifier func_gene chromosome position reference alternative driver_gene partner_gene).each{|moi_attr| query_hash[moi_attr] = moi[moi_attr] if moi[moi_attr].present?}

      # this does not have any effect !
      variants = NciMatchPatientModels::Variant.find_by(query_hash).collect { |data| data.to_h.compact }
      moi[:uuid] = variants[0][:uuid] if (variants.length > 0)
    end

    amoi_count
  end
end

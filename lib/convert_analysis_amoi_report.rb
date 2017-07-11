module Convert
  class AmoisRuleModel
    def self.to_ui_model(analysis_id, amois_from_rule=nil)
      return {} if analysis_id.blank?
      if amois_from_rule.blank?
        map = {:total_amois => 0, :snv_indels => [], :copy_number_variants => [], :gene_fusions => []}
        variants = NciMatchPatientModels::Variant.find_by({:analysis_id => analysis_id})
        variants.each do | variant |
          map_variant_type(variant).each do |k,v| map[k].push(v) end
        end
        return map
      else
        amois_from_rule.deep_symbolize_keys!
        snv_indel_amois = amois_only(amois_from_rule[:snv_indels])
        cnv_amois = amois_only(amois_from_rule[:copy_number_variants])
        fusion_amois = amois_only(amois_from_rule[:gene_fusions])

        count = snv_indel_amois.length + cnv_amois.length + fusion_amois.length

        return {:total_amois => count, :snv_indels => snv_indel_amois, :copy_number_variants => cnv_amois, :gene_fusions => fusion_amois}
      end
    end

    def self.amois_only(variants_by_type)
      return [] if variants_by_type.blank?
      amois = variants_by_type.select {|variant | !variant[:amois].blank?}
    end

    private
    def self.map_variant_type(variant)
      return {} if variant[:amois].blank?
      case variant[:variant_type]
        when 'fusion'
          {:gene_fusions => variant}
        when 'ins', 'snp'
          {:snv_indels => variant}
        when 'cnv'
          {:copy_number_variants => variant}
        else
          {}
      end
    end
  end
end
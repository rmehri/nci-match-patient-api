module Convert
  module AmoisRuleModel

    extend self

    def to_ui(amois_from_rule)
      return {} if amois_from_rule.blank?

      snv_indel_amois = amois_only(amois_from_rule[:snv_indels])
      cnv_amois       = amois_only(amois_from_rule[:copy_number_variants])
      fusion_amois    = amois_only(amois_from_rule[:gene_fusions])

      count = snv_indel_amois.length + cnv_amois.length + fusion_amois.length

      {:total_amois => count, :snv_indels => snv_indel_amois, :copy_number_variants => cnv_amois, :gene_fusions => fusion_amois}
    end

    def amois_only(variants_by_type)
      return [] if variants_by_type.blank?
      amois = variants_by_type.select {|variant | !variant[:amois].blank?}
    end
  end
end

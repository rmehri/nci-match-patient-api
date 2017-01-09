module Convert
  class VariantReportDbModel
    def self.to_ui_model(variant_report_db, variants_db, variant_report_with_amoi)

      variant_report = variant_report_db.to_h.deep_symbolize_keys
      variant_report[:snv_indels] = get_snv_indels(variants_db)
      variant_report[:copy_number_variants] = get_typed_variants(variants_db, "cnv")
      variant_report[:gene_fusions] = get_typed_variants(variants_db, "fusion")

      update_amois(variant_report[:snv_indels], variant_report_with_amoi[:snv_indels])
      update_amois(variant_report[:copy_number_variants], variant_report_with_amoi[:copy_number_variants])
      update_amois(variant_report[:gene_fusions], variant_report_with_amoi[:gene_fusions])

      update_statistics(variant_report, variants_db)
      variant_report
    end

    private

    def self.update_statistics(variant_report, variants_db)
      variant_report[:total_mois] = variants_db.length
      variant_report[:total_confirmed_mois] = variants_db.select {|v| v[:confirmed] == true}.length
      variant_report[:total_amois] = variants_db.select {|v| v[:amois].length > 0}.length
      variant_report[:total_confirmed_amois] = variants_db.select {|v| v[:confirmed] == true && v[:amois].length > 0}.length
    end

    def self.get_snv_indels(variants_db)
      snv_indels = []

      variants = get_typed_variants(variants_db, "snp")
      snv_indels.push(*variants)

      variants = get_typed_variants(variants_db, "mnp")
      snv_indels.push(*variants)

      variants = get_typed_variants(variants_db, "del")
      snv_indels.push(*variants)

      variants = get_typed_variants(variants_db, "ins")
      snv_indels.push(*variants)

      variants = get_typed_variants(variants_db, "complex")
      snv_indels.push(*variants)

    end

    def self.get_typed_variants(variants, variant_type)
      if variants != nil
        selected = variants
            .select {|v| v[:variant_type] == variant_type}
        selected
      else
        []
      end
    end

    def self.update_amois(db_variants, rule_variants)
      db_variants.each do | variant |
        variant[:amois] = get_amois(variant, rule_variants)
      end
    end

    def self.get_amois(db_variant, rule_variants)
      if !rule_variants.blank?
        selected = rule_variants
            .select {|v|
          v[:variant_type] == db_variant[:variant_type] &&
              v[:chromosome] == db_variant[:chromosome] &&
              v[:identifier] == db_variant[:identifier] }
        selected[0][:amois]
      else
        []
      end
    end
  end
end
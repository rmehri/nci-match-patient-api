module ApplicationHelper

  def self.format_treatment_arm_title(treatment_arm_hash)
    return "" if treatment_arm_hash.blank?

    treatment_arm_hash.deep_symbolize_keys!
    "#{treatment_arm_hash[:treatment_arm_id]} (#{treatment_arm_hash[:stratum_id]}, #{treatment_arm_hash[:version]})"
  end

  def self.merge_treatment_arm_fields(data_hash, selected_treatment_arm)
    return data_hash if selected_treatment_arm.blank?

    selected_treatment_arm.deep_symbolize_keys!
    data_hash[:treatment_arm_title] = "#{selected_treatment_arm[:treatment_arm_id]} (#{selected_treatment_arm[:stratum_id]}, #{selected_treatment_arm[:version]})"
    data_hash[:treatment_arm_id] = selected_treatment_arm[:treatment_arm_id]
    data_hash[:treatment_arm_stratum_id] = selected_treatment_arm[:stratum_id]
    data_hash[:treatment_arm_version] = selected_treatment_arm[:version]
    data_hash
  end

  def self.format_disease_names(diseases)
    return "" if diseases.blank?

    disease_names = ""
    diseases.each do | disease |
      disease.deep_symbolize_keys!
      disease_names = if disease_names.length == 0 then disease[:disease_name] else "#{disease_names}, #{disease[:disease_name]}" end
    end

    disease_names
  end

  def self.has_role(required_roles, current_user)
    return false if current_user.nil? || !(current_user.is_a? Hash)

    current_user.deep_symbolize_keys!
    return false if current_user[:roles].blank?

    current_user[:roles].each do |role|
      return true if required_roles.include? role
    end

    false
  end

  def self.replace_value_in_patient_message(message_hash, target_key, replacement)
    return message_hash if message_hash.blank?

    message_hash.each do |key, value |
      if (key.to_s == target_key)
        message_hash[key] = replacement
      elsif (value.is_a? Hash)
        replace_value_in_patient_message(value, target_key, replacement)
      end
    end

    message_hash
  end

  def self.trim_value_in_patient_message(message_hash)
    return message_hash if message_hash.blank?

    message_hash.deep_symbolize_keys!
    message_hash.each do |key, value |
      if (value.is_a? Hash)
        trim_value_in_patient_message(value)
      elsif (value.is_a? String)
        message_hash[key] = value.strip
      end
    end

    message_hash
  end

  def self.string_match(value, start_with, end_with)
    value =~ /^#{start_with}.*#{end_with}$/
  end

  def self.to_gene_name(assay_name)
    return assay_name unless ApplicationHelper.string_match(assay_name, "ICC", "s")

    assay_name[3..-2]
  end

end
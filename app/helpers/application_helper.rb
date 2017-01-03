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

    roles = current_user["roles"]
    return false if roles.blank?

    roles.each do |role|
      p "========== role: #{role}"
      return true if required_roles.include? role
    end

    false
  end
end
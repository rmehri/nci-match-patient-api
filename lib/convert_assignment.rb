module Convert
  class AssignmentDbModel
    # def self.to_ui(assignment_db, assays)
    #   assignment = assignment_db.deep_symbolize_keys
    #   assignment_results = assignment[:treatment_assignment_results]
    #   unless assignment_results.nil?
    #     assignment_logic = {}
    #     selected = nil
    #     assignment_results.each do |assignment_result|
    #       ta = {
    #           treatment_arm_id: assignment_result[:treatment_arm_id],
    #           stratum_id: assignment_result[:stratum_id],
    #           version: assignment_result[:version]
    #       }
    #       assignment_result[:treatment_arm] = ta
    #       assignment_result.delete(:treatment_arm_id)
    #       assignment_result.delete(:stratum_id)
    #       assignment_result.delete(:version)
    #
    #       selected = assignment_result if assignment_result[:assignment_status] == 'SELECTED'
    #       unless assignment_result[:assignment_status] == 'SELECTED'
    #         assignment_logic[assignment_result[:assignment_status]] ||= []
    #         assignment_logic[assignment_result[:assignment_status]].push(assignment_result)
    #       end
    #     end
    #
    #     if !selected.nil?
    #       assignment_logic[:SELECTED] = []
    #       assignment_logic[:SELECTED].push(selected)
    #     end
    #
    #     assignment[:treatment_assignment_results] = assignment_logic
    #   end
    #   assignment.delete(:patient) unless assignment[:patient].nil?
    #   assignment[:assays] = assays
    #   assignment
    # end

    def self.to_ui(assignment_db, assays)
      assignment = assignment_db.deep_symbolize_keys
      assignment_results = assignment[:treatment_assignment_results]
      assignment_logic = {}
      unless assignment_results.nil?
        # assignment_logic_types = assignment_results.uniq.collect{ | _data | _data[:assignment_status].to_sym }
        assignment_results.each do | assignment_result |
          assignment_result[:treatment_arm] = {
              treatment_arm_id: assignment_result[:treatment_arm_id],
              stratum_id: assignment_result[:stratum_id],
              version: assignment_result[:version]
          }
          assignment_result.except!(:treatment_arm_id, :stratum_id, :version)
          assignment_logic[assignment_result[:assignment_status]] ||= []
          assignment_logic[assignment_result[:assignment_status]].push(assignment_result)
        end
      end
      assignment_logic.deep_symbolize_keys!
      assignment_logic[:SELECTED] = assignment_logic.delete(:SELECTED) unless assignment_logic[:SELECTED].blank?
      assignment[:treatment_assignment_results] = assignment_logic
      assignment.delete(:patient) unless assignment[:patient].nil?
      assignment[:assays] = assays
      assignment
    end
  end
end

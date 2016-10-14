module Convert
  class AssignmentDbModel
    def self.to_ui(assignment_db, assays)
      assignment = assignment_db.to_h.deep_symbolize_keys

      puts "========= assays: #{assays.to_json}"

      patient = assignment[:patient]
      assignment_results = assignment[:treatment_assignment_results]

      assignment_logic = {}
      assignment_results.each do |assignment_result|
        ta = {:name => assignment_result[:treatment_arm_id],
              :stratum => assignment_result[:stratum_id],
              :version => assignment_result[:version]}

        assignment_result[:treatment_arm] = ta
        assignment_result.delete(:treatment_arm_id)
        assignment_result.delete(:stratum_id)
        assignment_result.delete(:version)

        assignment_logic[assignment_result[:assignment_status]] ||= []
        assignment_logic[assignment_result[:assignment_status]].push(assignment_result)
      end

      assignment[:treatment_assignment_results] = assignment_logic
      assignment.delete(:patient) if !assignment[:patient].nil?
      assignment[:assays] = assays
      assignment
    end
  end
end
class Assay
  attr_accessor :biomarker,
                :ordered_date,
                :result_date,
                :result

  def initialize(biomarker)
    @biomarker = biomarker
  end
end
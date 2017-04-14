module MessageValidator
  module VariantReportStatusValidator
    extend ActiveSupport::Concern

    included do
      validates :patient_id, presence: true
      validates :analysis_id, presence: true
      validates :status, presence: true,
                inclusion: {in: %w(CONFIRMED REJECTED), message: "%{value} is not a valid variant report status value"}
    end

  end

end

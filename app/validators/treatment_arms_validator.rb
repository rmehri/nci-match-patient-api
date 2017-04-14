module MessageValidator
  module TreatmentArmsValidator
    extend ActiveSupport::Concern

    included do
      validates :treatment_arms, presence: true
    end

  end
end

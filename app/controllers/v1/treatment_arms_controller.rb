module V1
  class TreatmentArmController < BaseController
    before_action :authenticate_user
    include Knock::Authenticable

    def create
      authorize! :create, :System
      Rails.cache.write("treatment_arms_updated", Time.now.utc)

      # message = JSON.parse(json).deep_transform_keys!(&:underscore).symbolize_keys
      # JobBuilder.new("TreatmentArms::UpdateVariantReportJob").job.perform_later(request.raw_post)
    end

  end
end
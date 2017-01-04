class Ability
  include CanCan::Ability

  def initialize(user = {})
    user.deep_symbolize_keys!
    user.store(:roles, []) unless user.include?(:roles)
    accessible_methods = []
    user[:roles].each do | role |
      begin
        accessible_methods << role.downcase.classify.constantize.get_methods
      rescue NameError
        accessible_methods = []
      end
    end
    can accessible_methods, :all
  end
end

module Admin
  module ClassMethods
    def get_methods
      :manage
    end
  end
  extend ClassMethods
  def self.included(base)
    base.extend( ClassMethods )
  end
end

module PatientMessageSender
  module ClassMethods
    def get_methods
      :trigger
    end
  end
  extend ClassMethods
  def self.included(base)
    base.extend( ClassMethods )
  end
end

module MochaVariantReportReviewer
  module ClassMethods
    def get_methods
      :variant_report_status
    end
  end
  extend ClassMethods
  def self.included(base)
    base.extend( ClassMethods )
  end
end

module AssignmentReportReviewer
  module ClassMethods
    def get_methods
      :assignment_confirmation
    end
  end
  extend ClassMethods
  def self.included(base)
    base.extend( ClassMethods )
  end
end

module System include Admin; end
module SpecimenMessageSender include PatientMessageSender; end
module AssayMessageSender include PatientMessageSender; end
module VariantReportSender include PatientMessageSender; end
module MdaVariantReportReviewer include MochaVariantReportReviewer; end
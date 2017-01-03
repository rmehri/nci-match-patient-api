class Ability
  include CanCan::Ability

  def initialize(user)
    user.deep_symbolize_keys!
    list_of_methods = []
    user[:roles].each do | role |
      begin
        self.class.send(:include, role.downcase.classify.constantize)
      rescue NameError
        can :manage, :none
      end
      list_of_methods << self.get_methods
    end
    can list_of_methods, :all
  end
end

module Admin
  def get_methods
    :manage
  end
end

module PatientMessageSender
  def get_methods
    :trigger
  end
end

module MochaVariantReportReviewer
  def get_methods
    :variant_report_status
  end
end

module AssignmentReportReviewer
  def get_methods
    :assignment_confirmation
  end
end

module System extend Admin; end
module SpecimenMessageSender extend PatientMessageSender; end
module AssayMessageSender extend PatientMessageSender; end
module VariantReportSender extend PatientMessageSender; end
module MdaVariantReportReviewer extend MochaVariantReportReviewer; end
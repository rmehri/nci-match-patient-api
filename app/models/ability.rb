class Ability
  include CanCan::Ability

  attr_reader :methods

  def initialize(user = {})
    user.deep_symbolize_keys!
    user = user.dig(:roles) || []
    user.each do | role |
      begin
        methods << role.downcase.classify.constantize.get_methods
      rescue NameError
        methods = []
      end
    end
    can methods, :all
  end

  def methods
    @methods ||= []
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
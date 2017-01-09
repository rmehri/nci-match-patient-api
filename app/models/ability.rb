class Ability
  include CanCan::Ability

  attr_reader :methods

  def initialize(user = {})
    user.deep_symbolize_keys!
    user = user.dig(:roles) || []
    user.each do | role |
      begin
        methods << "NciMatchRoles::#{role.downcase.classify}".constantize.get_methods
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

NciMatchRoles::Admin.instance_eval { def get_methods; :manage; end }
NciMatchRoles::PatientMessageSender.instance_eval { def get_methods; :trigger; end }
NciMatchRoles::MochaVariantReportReviewer.instance_eval { def get_methods; :variant_report_status; end }
NciMatchRoles::AssignmentReportReviewer.instance_eval { def get_methods; :assignment_confirmation; end }
NciMatchRoles::System.instance_eval { def get_methods; :manage; end }
NciMatchRoles::SpecimenMessageSender.instance_eval { def get_methods; :trigger; end }
NciMatchRoles::AssayMessageSender.instance_eval { def get_methods; :trigger; end }
NciMatchRoles::VariantReportSender.instance_eval { def get_methods; :trigger; end }
NciMatchRoles::MdaVariantReportReviewer.instance_eval { def get_methods; :variant_report_status; end }
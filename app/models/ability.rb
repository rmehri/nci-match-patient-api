class Ability
  include CanCan::Ability

  def initialize(user)
    user.deep_symbolize_keys!
    list_of_methods = []
    user[:roles].each do | role |
      case role.to_sym
        when :ADMIN
          list_of_methods << :manage
        when :SYSTEM
          can :manage, :all
        when :PATIENT_MESSAGE_SENDER, :SPECIMEN_MESSAGE_SENDER, :ASSAY_MESSAGE_SENDER, :VARIANT_REPORT_SENDER
          list_of_methods << :trigger
        when :MOCHA_VARIANT_REPORT_REVIEWER, :MDA_VARIANT_REPORT_REVIEWER
          list_of_methods << :variant_report_status
        when :ASSIGNMENT_REPORT_REVIEWER
          list_of_methods << :assignment_confirmation
        else
          can :manage, :none
      end
    end
    can list_of_methods, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end

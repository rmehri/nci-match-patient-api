class Ability
  include CanCan::Ability

  attr_reader :methods, :subjects

  def initialize(user = {})
    user.deep_symbolize_keys!
    user = user.dig(:roles) || []
    user.each do | role |
      begin
        clazz = "NciMatchRoles::#{role.downcase.classify}".constantize
        methods << clazz.get_methods
        subjects << clazz.get_subjects
      rescue NameError
        methods = []
      end
    end
    can methods, subjects.flatten
  end

  def methods
    @methods ||= []
  end

  def subjects
    @subjects ||= []
  end

end

NciMatchRoles::Admin.instance_eval { def get_methods; :manage; end; def get_subjects; :all; end }
NciMatchRoles::System.instance_eval { def get_methods; :manage; end; def get_subjects; :all; end }

NciMatchRoles::PatientMessageSender.instance_eval do
  def get_methods; [:trigger, :validate_json_message]; end;
  def get_subjects; [:Cog, :TreatmentArm, NciMatchPatientModels]; end;
end

NciMatchRoles::AssignmentReportReviewer.instance_eval do
  def get_methods; [:assignment_confirmation, :validate_json_message]; end;
  def get_subjects; [:AssignmentStatus, NciMatchPatientModels]; end;
end

NciMatchRoles::SpecimenMessageSender.instance_eval do
  def get_methods; [:trigger, :validate_json_message]; end;
  def get_subjects; [:SpecimenReceived, :SpecimenShipped, NciMatchPatientModels]; end
end

NciMatchRoles::AssayMessageSender.instance_eval do
  def get_methods; [:trigger, :validate_json_message]; end
  def get_subjects; [:Assay, NciMatchPatientModels]; end
end

NciMatchRoles::MdaVariantReportSender.instance_eval do
  def get_methods; [:variant_report_uploaded, :validate_json_message]; end
  def get_subjects; [NciMatchPatientModels, :VariantReport, :MDA, :Event]; end
end

NciMatchRoles::MdaVariantReportReviewer.instance_eval do
  def get_methods; [:variant_status, :variant_report_status, :validate_json_message]; end;
  def get_subjects; [NciMatchPatientModels, :VariantReportStatus, :MDA]; end;
end

NciMatchRoles::MochaVariantReportSender.instance_eval do
  def get_methods; [:variant_report_uploaded, :validate_json_message]; end
  def get_subjects; [NciMatchPatientModels, :VariantReport, :MoCha, :Event]; end
end

NciMatchRoles::MochaVariantReportReviewer.instance_eval do
  def get_methods; [:variant_status, :variant_report_status, :validate_json_message]; end;
  def get_subjects; [NciMatchPatientModels, :VariantReportStatus, :MoCha]; end;
end

NciMatchRoles::DartmouthVariantReportReviewer.instance_eval do
  def get_methods; [:variant_status, :variant_report_status, :validate_json_message]; end;
  def get_subjects; [NciMatchPatientModels, :VariantReportStatus, :Dartmouth]; end;
end

NciMatchRoles::DartmouthVariantReportSender.instance_eval do
  def get_methods; [:variant_status, :variant_report_status, :validate_json_message]; end;
  def get_subjects; [NciMatchPatientModels, :VariantReportStatus, :Dartmouth]; end;
end

class JobBuilder

  attr_reader :job

  def initialize(name)
    @job = build(name)
  end

  private
  def build(name)
    begin
      Object.const_get(name.classify)
    rescue NameError => error
      Rails.logger.info("Class #{name.classify} does NOT exist yet and will be created")
      Object.const_set(name.classify, Class.new(ActiveJob::Base) {queue_as "#{Rails.configuration.environment.fetch('queue_name')}"})
      # name = name.split("::")
      # if(name.length > 1)
      #   create_class(name.pop, build_module(name).to_s)
      # else
      #   create_class(name.pop)
      # end
    end
  end

  # Specimen = Module.new
  # Specimen::ReceivedJob = Class.new(ActiveJob::Base) {queue_as "#{Rails.configuration.environment.fetch('queue_name')}"} }
  # Object.const_set("Specimen", Module.new)
  # Object.const_get("Specimen").const_set("ReceivedJob", Class.new(ActiveJob::Base) {queue_as "#{Rails.configuration.environment.fetch('queue_name')}"} })

  def create_class(class_name, name_space=nil)
    unless name_space.blank?
      Object.const_get(name_space).const_set(class_name, Class.new(ActiveJob::Base) {queue_as "#{Rails.configuration.environment.fetch('queue_name')}"})
    end
    Object.const_set(class_name, Class.new(ActiveJob::Base) {queue_as "#{Rails.configuration.environment.fetch('queue_name')}"})
  end

  # Builds out Namespace for class
  # Example: given ["Cat", "Dog"] it will create a Cat::Dog module
  def build_module(name)
    return Object if name.blank?
    current_name = name.pop
    object = build_module(name)
    object.const_set(current_name.classify, Module.new)
  end


end
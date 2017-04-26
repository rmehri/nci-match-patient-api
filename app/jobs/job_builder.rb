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
    end
  end

end
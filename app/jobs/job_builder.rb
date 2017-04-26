class JobBuilder

  attr_reader :job

  def initialize(name)
    @job = name
  end

  def build
    begin
      Object.const_get(@job.classify)
    rescue NameError => error
      Rails.logger.info("Class #{@job.classify} does NOT exist yet and will be created")
      Object.const_set(@job.classify, Class.new(ActiveJob::Base) {queue_as "#{Rails.configuration.environment.fetch('queue_name')}"})
    end
  end

end
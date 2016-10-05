class Log < ActiveRecord::Base
  validates :level, :area, :message, presence: true

  LEVELS = [
    ERROR_LEVEL = 'error',
    INFO_LEVEL = 'info'
  ].freeze

  AREAS = [
    BAIDU_AREA = 'baidu'
  ].freeze

  after_create :trace_to_log_file, :trace_to_console

  #TODO: send email?

  def self.write level, area, class_name, method_name, message, backtrace=nil, context={}
    Log.create({
      level: level,
      area: area,
      class_name: class_name,
      method_name: method_name,
      message: message,
      backtrace: backtrace,
      context: context
    })
    nil
  end

  def self.error area, class_name, method_name, error, context={}
    message = error.message
    backtrace = (error.backtrace || []).join("\n")
    Log.write(Log::ERROR_LEVEL, area, class_name, method_name, message, backtrace, context)
  end

  def self.info area, class_name, method_name, message, context={}
    Log.write(Log::INFO_LEVEL, area, class_name, method_name, message, nil, context)
  end

  private

  def trace_to_log_file
    Rails.logger.error "#LOG ##{self.level.to_s.upcase} ************************************"
    Rails.logger.error "#{self.class_name}/#{self.method_name}"
    Rails.logger.error self.message
    Rails.logger.error (self.context || {}).map{|k, v| "#{k}: #{v}" }.join("\n")
    Rails.logger.error self.backtrace
  end

  def trace_to_console
    if Rails.env.development?
      puts "#LOG ##{self.level.to_s.upcase} ************************************"
      puts "#{self.class_name}/#{self.method_name}"
      puts self.message
      puts (self.context || {}).map{|k, v| "#{k}: #{v}" }.join("\n")
      puts self.backtrace
    end
  end
end

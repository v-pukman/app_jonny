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

  scope :errors, -> { where(level: ERROR_LEVEL) }
  scope :infos, -> { where(level: INFO_LEVEL) }

  #TODO: send email?

  def self.clear select_options
    Log.transaction do
      Log.where(select_options).destroy_all
    end
  end


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
    if self.level.to_s == ERROR_LEVEL
      Rails.logger.error "#LOG #ERROR #{'X'*36}"
    else
      Rails.logger.error "#LOG ##{self.level.to_s.upcase} #{'*'*36}"
    end

    Rails.logger.error "#{self.class_name}/#{self.method_name}"
    Rails.logger.error self.message

    if self.context.is_a?(Hash)
      Rails.logger.error self.context.map{|k, v| "#{k}: #{v}" }.join("\n")
    else
      Rails.logger.error self.context
    end

    Rails.logger.error self.backtrace
  end

  def trace_to_console
    if Rails.env.development?
      if self.level.to_s == ERROR_LEVEL
        puts "#LOG #ERROR #{'X'*36}"
      else
        puts "#LOG ##{self.level.to_s.upcase} #{'*'*36}"
      end

      puts "#{self.class_name}/#{self.method_name}"
      puts self.message

      if self.context.is_a?(Hash)
        puts self.context.map{|k, v| "#{k}: #{v}" }.join("\n")
      else
        puts self.context
      end

      puts self.backtrace
    end
  end
end

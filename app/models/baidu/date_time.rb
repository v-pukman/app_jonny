class Baidu::DateTime
  TIMEZONE = 'Beijing'
  def self.current_time
    Time.now.in_time_zone TIMEZONE
  end

  def self.current_date
    self.now.to_date
  end
end

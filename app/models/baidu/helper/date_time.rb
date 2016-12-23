class Baidu::Helper::DateTime
  TIMEZONE = 'Beijing'

  def self.time_with_zone
    Time.now.in_time_zone TIMEZONE
  end

  def self.curr_time
    time_with_zone
  end

  def self.curr_date
    time_with_zone.to_date
  end
end

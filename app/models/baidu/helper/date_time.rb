class Baidu::Helper::DateTime
  TIMEZONE = 'Beijing'
  def self.curr_time
    Time.now.in_time_zone TIMEZONE
  end
  def self.curr_date
    self.now.to_date
  end
end

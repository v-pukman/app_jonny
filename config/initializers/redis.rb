config = Rails.application.config_for :redis
RedisClient = Redis.new config

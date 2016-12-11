redis_config = Rails.application.config_for :redis
redis_params = { url: "redis://#{redis_config['host']}:#{redis_config['port']}/#{redis_config['db']}" }

Sidekiq.configure_client do |config|
  config.redis = redis_params
end
Sidekiq.configure_server do |config|
  config.redis = redis_params
end

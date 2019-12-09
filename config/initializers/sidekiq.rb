Sidekiq::Extensions.enable_delay!

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_SERVER']}:6379" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['REDIS_SERVER']}:6379" }
end
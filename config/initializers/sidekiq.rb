Sidekiq::Extensions.enable_delay!

Sidekiq.configure_server do |config|
  config.redis = { url: "#{ENV['REDIS_URL']}", password: "#{ENV['REDIS_PWD']}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "#{ENV['REDIS_URL']}", password: "#{ENV['REDIS_PWD']}" }
end
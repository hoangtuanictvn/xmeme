Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, ENV['FACEBOOK_CLIENT_ID'], ENV['FACEBOOK_CLIENT_SECRET']
    provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET']
end
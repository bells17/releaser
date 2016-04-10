Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Settings.api.twitter.consumer_key, Settings.api.twitter.consumer_secret
end

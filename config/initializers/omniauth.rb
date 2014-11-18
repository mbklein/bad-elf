Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :facebook,      ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'] if ENV['FACEBOOK_KEY']
  provider :twitter,       ENV['TWITTER_KEY'],  ENV['TWITTER_SECRET']  if ENV['TWITTER_KEY']
  provider :google_oauth2, ENV["GOOGLE_KEY"],   ENV["GOOGLE_SECRET"]   if ENV['GOOGLE_KEY']
end

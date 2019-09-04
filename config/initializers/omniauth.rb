facebook_config = {
  scope: 'email', 
  info_fields: 'email,name',
  callback_url: ENV['FACEBOOK_CALLBACK_URL']
}.reject { |k,v| v.nil? }

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], facebook_config if ENV['FACEBOOK_KEY']
  provider :google_oauth2, ENV["GOOGLE_KEY"],   ENV["GOOGLE_SECRET"]  if ENV['GOOGLE_KEY']
end

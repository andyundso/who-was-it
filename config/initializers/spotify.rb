RSpotify::authenticate(Rails.application.credentials.spotify_client_id, Rails.application.credentials.spotify_client_secret)

require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, Rails.application.credentials.spotify_client_id, Rails.application.credentials.spotify_client_secret, scope: 'playlist-read-collaborative'
end

OmniAuth.config.allowed_request_methods = [:post, :get]

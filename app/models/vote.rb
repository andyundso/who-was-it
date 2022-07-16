class Vote < ApplicationRecord
  validates_uniqueness_of :spotify_track_id, scope: [:spotify_playlist_id, :spotify_user_id]
end

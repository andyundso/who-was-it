class PlaylistsController < ApplicationController
  before_action :set_playlist, only: %i[show]
  before_action :set_playlist_tracks, only: %i[show]

  def index
    @playlists = spotify_user.playlists(limit: 50)
  end

  def show
    @votes = Vote.where(spotify_playlist_id: params[:id])
                 .group('votes.spotify_user_id')
                 .order("value_sum desc")
                 .pluck("votes.spotify_user_id, sum(votes.value) as value_sum, count(votes.value) as value_count")

    Rails.logger.info @votes.inspect
  end
end

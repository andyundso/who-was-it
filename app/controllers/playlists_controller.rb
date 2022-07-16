class PlaylistsController < ApplicationController
  def index
    @playlists = spotify_user.playlists
  end

  def show
    @votes = Vote.where(spotify_playlist_id: params[:id])
               .group('votes.spotify_user_id')
               .pluck("votes.spotify_user_id, sum(votes.value) as value_sum")
  end
end

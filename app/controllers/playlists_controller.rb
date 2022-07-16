class PlaylistsController < ApplicationController
  before_action :set_playlist, except: %i[index]
  before_action :set_playlist_tracks, except: %i[index]

  def create_vote
    vote = Vote.new(vote_params)
    vote.spotify_playlist_id = params[:id]
    vote.spotify_user_id = spotify_user.id
    vote.value = vote.guess == @tracks_added_by[vote.spotify_track_id].id ? 1 : 0
    vote.save

    redirect_to random_playlist_path
  end

  def index
    @playlists = spotify_user.playlists
  end

  def random
    voted_tracks = Vote.where(spotify_user_id: spotify_user.id, spotify_playlist_id: params[:id]).pluck(:spotify_track_id)

    @track = @tracks
               .shuffle
               .first { |spotify_track| voted_tracks.exclude? spotify_track.id }

    @vote = Vote.new(spotify_track_id: @track.id, spotify_playlist_id: params[:id])
  end

  def show
    @votes = Vote.where(spotify_playlist_id: params[:id])
                 .group('votes.spotify_user_id')
                 .pluck("votes.spotify_user_id, sum(votes.value) as value_sum, count(votes.value) as value_count")

    Rails.logger.info @votes.inspect
  end

  private

  def vote_params
    params.require(:vote).permit(:guess, :spotify_track_id)
  end

  def set_playlist
    @playlist = Rails.cache.fetch("playlist/#{params[:id]}", expires_in: 1.hour) do
      RSpotify::Playlist.find(spotify_user.id, params[:id])
    end
  end

  def set_playlist_tracks
    @tracks, @tracks_added_by, @playlist_users = Rails.cache.fetch("playlist/#{params[:id]}/tracks", expires_in: 1.hour) do
      Rails.logger.info "fetching data from Spotify API ..."

      tracks = []
      tracks_added_by = {}
      playlist_users = {}
      offset = 0

      while tracks.count < @playlist.total do
        tracks << @playlist.tracks(offset: offset * 100)
        tracks = tracks.flatten

        tracks_added_by = tracks_added_by.merge(@playlist.tracks_added_by)
        tracks_added_by.map { |_track, user| playlist_users[user.id] = user.display_name unless playlist_users[user.id] }

        offset += 1
      end

      [tracks.uniq, tracks_added_by, playlist_users]
    end
  end
end

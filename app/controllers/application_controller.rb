class ApplicationController < ActionController::Base
  before_action :check_spotify_user

  private

  def check_spotify_user
    if session[:spotify_user_id].nil?
      redirect_to sign_in_path
    end
  end

  protected

  def set_playlist
    @playlist = Rails.cache.fetch("playlist/#{params[:playlist_id] || params[:id]}", expires_in: 1.hour) do
      RSpotify::Playlist.find(spotify_user.id, (params[:playlist_id] || params[:id]))
    end
  end

  def set_playlist_tracks
    @tracks, @tracks_added_by, @playlist_users = Rails.cache.fetch("playlist/#{params[:playlist_id] || params[:id]}/tracks", expires_in: 1.hour) do
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

  def spotify_user
    @spotify_user ||= RSpotify::User.new(session[:spotify_user_id])
  end
end

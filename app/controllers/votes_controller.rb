class VotesController < ApplicationController
  before_action :set_playlist
  before_action :set_playlist_tracks

  def create
    vote = Vote.new(vote_params.except(:mode))
    result = vote.guess == @tracks_added_by[vote.spotify_track_id].id

    vote.spotify_playlist_id = params[:playlist_id]
    vote.spotify_user_id = spotify_user.id
    vote.value = result ? 1 : 0

    if vote.save
      if result
        flash.notice = "Correct! The track was indeed added by #{@playlist_users[vote.guess]}."
      else
        flash.alert = "Sorry, this track was actually added by #{@tracks_added_by[vote.spotify_track_id].display_name} and not by #{@playlist_users[vote.guess]}."
      end
    else
      flash.alert = "Sorry, there was an issue on our side. Try again."
    end

    if vote_params[:mode] == "random"
      redirect_to random_playlist_votes_path(params[:playlist_id])
    else
      redirect_to search_playlist_votes_path(params[:playlist_id])
    end
  end

  def new
    @track = @tracks.find { |spotify_track| spotify_track.id == params[:spotify_track_id] }
    @vote = Vote.new(spotify_track_id: @track.id, spotify_playlist_id: params[:playlist_id])
    @mode = "selective"
  end

  def random
    voted_tracks = Vote.where(spotify_user_id: spotify_user.id, spotify_playlist_id: params[:playlist_id]).pluck(:spotify_track_id)

    @track = @tracks
               .shuffle
               .first { |spotify_track| voted_tracks.exclude? spotify_track.id }

    @vote = Vote.new(spotify_track_id: @track.id, spotify_playlist_id: params[:playlist_id])

    @mode = "random"

    render :new
  end

  def search
    voted_tracks = Vote.where(spotify_user_id: spotify_user.id, spotify_playlist_id: params[:playlist_id]).pluck(:spotify_track_id)
    @open_tracks = @tracks.select { |spotify_track| voted_tracks.exclude? spotify_track.id }
  end

  private

  def vote_params
    params.require(:vote).permit(:guess, :spotify_track_id, :mode)
  end
end

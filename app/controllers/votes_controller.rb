class VotesController < ApplicationController
  before_action :set_playlist
  before_action :set_playlist_tracks

  def create
    vote = Vote.new(vote_params)
    vote.spotify_playlist_id = params[:playlist_id]
    vote.spotify_user_id = spotify_user.id
    vote.value = vote.guess == @tracks_added_by[vote.spotify_track_id].id ? 1 : 0
    vote.save

    redirect_to random_playlist_votes_path(params[:playlist_id])
  end

  def new
    @track = @tracks.find { |spotify_track| spotify_track.id == params[:spotify_track_id] }
    @vote = Vote.new(spotify_track_id: @track.id, spotify_playlist_id: params[:playlist_id])
  end

  def random
    voted_tracks = Vote.where(spotify_user_id: spotify_user.id, spotify_playlist_id: params[:playlist_id]).pluck(:spotify_track_id)

    @track = @tracks
               .shuffle
               .first { |spotify_track| voted_tracks.exclude? spotify_track.id }

    @vote = Vote.new(spotify_track_id: @track.id, spotify_playlist_id: params[:playlist_id])

    render :new
  end

  private

  def vote_params
    params.require(:vote).permit(:guess, :spotify_track_id)
  end
end

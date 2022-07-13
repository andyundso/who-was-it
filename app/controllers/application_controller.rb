class ApplicationController < ActionController::Base
  before_action :check_spotify_user

  private

  def check_spotify_user
    if session[:spotify_user_id].nil?
      redirect_to sign_in_path
    end
  end

  protected

  def spotify_user
    @spotify_user ||= RSpotify::User.new(session[:spotify_user_id])
  end
end

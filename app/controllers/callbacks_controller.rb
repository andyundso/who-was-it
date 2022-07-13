class CallbacksController < ActionController::Base
  def spotify
    session[:spotify_user_id] = request.env['omniauth.auth']
    redirect_to playlists_path
  end
end

class SignInController < ApplicationController
  skip_before_action :check_spotify_user

  def index; end
end

class AddVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.string :spotify_user_id
      t.string :spotify_playlist_id
      t.string :spotify_track_id
      t.integer :value
    end
  end
end

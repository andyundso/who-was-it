class AddVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.string :spotify_user_id, null: false
      t.string :spotify_playlist_id, null: false
      t.string :spotify_track_id, null: false
      t.string :guess, null: false

      t.integer :value
    end
  end
end

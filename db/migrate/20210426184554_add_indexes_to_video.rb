class AddIndexesToVideo < ActiveRecord::Migration[6.1]
  def change
    add_index :videos, :youtube_artist
    add_index :videos, :youtube_song
    add_index :videos, :spotify_track_name
    add_index :videos, :spotify_artist_name
    add_index :videos, :acr_cloud_track_name
    add_index :videos, :acr_cloud_artist_name
    add_index :videos, :tags
    add_index :videos, :upload_date
    add_index :videos, :popularity
    add_index :videos, :view_count
    add_index :videos, :hd
    add_index :videos, :hidden
  end
end

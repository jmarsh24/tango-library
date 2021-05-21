class AddReviewedToPlaylist < ActiveRecord::Migration[6.1]
  def change
    add_column :playlists, :reviewed, :boolean, default: false
  end
end

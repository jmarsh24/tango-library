class AddIndexToSong < ActiveRecord::Migration[6.1]
  def change
    add_index :songs, :last_name_search
  end
end

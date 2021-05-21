class AddIndexesToChannel < ActiveRecord::Migration[6.1]
  def change
    add_index :channels, :title
  end
end

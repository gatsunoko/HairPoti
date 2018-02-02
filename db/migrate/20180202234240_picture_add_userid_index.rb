class PictureAddUseridIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :pictures, :user_id
  end
end

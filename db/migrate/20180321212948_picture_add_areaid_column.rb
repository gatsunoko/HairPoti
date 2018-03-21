class PictureAddAreaidColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :prefecture_id, :integer
    add_column :pictures, :municipality_id, :integer
  end
end

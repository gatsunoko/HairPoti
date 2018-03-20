class PictureAddManyColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :length, :integer
    add_column :pictures, :color, :integer
  end
end

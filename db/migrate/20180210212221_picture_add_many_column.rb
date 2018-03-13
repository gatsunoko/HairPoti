class PictureAddManyColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :length, :string, index: true
    add_column :pictures, :color, :string, index: true
    add_column :pictures, :picture_front, :string
    add_column :pictures, :picture_side, :string
    add_column :pictures, :picture_back, :string
    remove_colum :pictures, :url
  end
end

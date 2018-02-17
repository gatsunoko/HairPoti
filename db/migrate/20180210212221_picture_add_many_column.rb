class PictureAddManyColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :length, :string, index: true
    add_column :pictures, :color, :string, index: true
  end
end

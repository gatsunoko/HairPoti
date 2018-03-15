class PictureAddTextColumn < ActiveRecord::Migration[5.0]
  def change
    remove_column :pictures, :url
    add_column :pictures, :text, :text
  end
end

class PictureAddPicturePresentColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :picture_present, :boolean, null: false, default: true
  end
end

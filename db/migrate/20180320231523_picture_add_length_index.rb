class PictureAddLengthIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :pictures, :length
  end
end

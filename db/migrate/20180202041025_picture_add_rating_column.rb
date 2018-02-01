class PictureAddRatingColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :rating, :integer, null: false, default: 1500
  end
end

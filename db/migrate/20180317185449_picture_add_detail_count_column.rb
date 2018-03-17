class PictureAddDetailCountColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :detail_count, :integer
  end
end
